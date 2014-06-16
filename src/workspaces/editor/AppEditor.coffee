
define [
  "./StackEditor"
  "./AppView"
  "ResDiff"
  "OpsModel"
  "Design"
  "CloudResources"
  "constant"
], ( StackEditor, AppView, ResDiff, OpsModel, Design, CloudResources, constant )->

  class AppEditor extends StackEditor

    title      : ()-> @opsModel.get("name") + " - app"
    createView : ()-> new AppView({workspace:this})
    tabClass   : ()->
      switch @opsModel.get("state")
        when OpsModel.State.Running
          return "icon-app-running"
        when OpsModel.State.Stopped
          return "icon-app-stopped"
        else
          return "icon-app-pending"

    isReady : ()-> !!@__hasAdditionalData

    fetchAdditionalData : ()->
      self = @

      region      = @opsModel.get("region")
      stateModule = @opsModel.getJsonData().agent.module

      Q.all([
        App.model.fetchStateModule( stateModule.repo, stateModule.tag )
        CloudResources( constant.RESTYPE.AZ,   region ).fetch()
        CloudResources( constant.RESTYPE.SNAP, region ).fetch()
        CloudResources( constant.RESTYPE.DHCP, region ).fetch()
        CloudResources( "QuickStartAmi",       region ).fetch()
        CloudResources( "MyAmi",               region ).fetch()
        CloudResources( "FavoriteAmi",         region ).fetch()
        CloudResources( "OpsResource", @opsModel.getVpcId() ).init( @opsModel.get("region") ).fetchForce()
      ]).then ()->
        # Hack, immediately apply changes when we get data if the app is changed.
        # Will move it to somewhere else if the process is upgraded.

        if self.isRemoved() then return

        newJson = self.opsModel.generateJsonFromRes()
        self.differ = new ResDiff({
          old : self.opsModel.getJsonData()
          new : newJson
        })
        result = self.differ.getChangeInfo()
        if result.hasResChange
          return self.opsModel.saveApp( newJson )
        else
          self.differ = undefined
        return

    isModified : ()-> @isAppEditMode() && @design && @design.isModified()

    isAppEditMode : ()-> !!@__appEdit

    initDesign : ()->
      StackEditor.prototype.initDesign.call this
      if @differ then @differ.render()
      return

    refreshResource : ()->

    switchToEditMode : ()->
      if @isAppEditMode() then return
      @__appEdit = true
      @design.setMode( Design.MODE.AppEdit )
      @view.switchMode( true )
      return

    cancelEditMode : ( force )->
      modfied = if force then true else @design.isModified()

      if modfied and not force then return false

      @__appEdit = false
      if modfied
        # Layout and component changes, need to construct a new Design.
        @view.emptyCanvas()
        @design = new Design( @opsModel )
        @initDesign()
      else
        @design.setMode( Design.MODE.App )

      @view.switchMode( false )
      true

    applyAppEdit : ( modfiedData, force )->
      modfied = modfiedData or @design.isModified( undefined, true )

      if modfied and not force then return modfied

      if not modfied
        @__appEdit = false
        @design.setMode( Design.MODE.App )
        @view.switchMode( false )
        return true

      self = @
      @__applyingUpdate = true

      @opsModel.update( modfied.newData, !modfied.component ).then ()->
        self.__applyingUpdate = false
        self.__appEdit = false

        self.view.stopListening self.opsModel, "change:progress", self.view.updateProgress

        self.design.setMode( Design.MODE.App )
        self.view.showUpdateStatus()
        self.view.switchMode( false )

        self.saveThumbnail()

        return

      , ( err )->
        self.__applyingUpdate = false
        self.view.stopListening self.opsModel, "change:progress", self.view.updateProgress

        msg = err.msg
        if err.result then msg += "<br />" + err.result

        self.view.showUpdateStatus( msg )
        return

      @view.listenTo @opsModel, "change:progress", @view.updateProgress

      true

    onOpsModelStateChanged : ()->
      if not @isInited() then return

      @updateTab()
      @view.toggleProcessing()

      StackEditor.prototype.onOpsModelStateChanged.call this


  AppEditor
