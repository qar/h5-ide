
define [ "constant", "../ConnectionModel", "CanvasManager", "Design" ], ( constant, ConnectionModel, CanvasManager, Design )->

  # SgAsso is used to represent that one Resource is using on SecurityGroup
  SgAsso = ConnectionModel.extend {
    type : "SgAsso"

    initialize : ()->

      # A hack for optimization.
      # When deserializing, shouldDraw() returns false.
      # Thus this sgAsso doesn't have a draw() method.
      # So that the Design won't call it after deserialization.
      # Then we update all resources in the callback of `deserialized`
      if Design.instance().shouldDraw()
        # Assign to draw after deserialization to make sure ConnectionModel
        # will draw us after connetion is established
        @draw = @updateLabel

      # Listen to Sg's name change, so that we could update the label tooltip
      @listenTo @getTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup ), "change:name", @updateLabel

      # Update target's label after this connection is removed.
      @on "destroy", @updateLabel
      null

    # Return false, so that ConnectionModel will not create an line for us.
    isVisual : ()-> false

    remove : ()->
      ConnectionModel.prototype.remove.apply this, arguments

      # When an SgAsso is removed because of an SecurityGroup is removed.
      # If this SgAsso is the last SgAsso of some resources, attach DefaultSg to these resources.
      resource = @getOtherTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup )
      if resource.isRemoved() # and resource.type is 'ExpandedAsg'
        return

      # When A is removed, and A delete an Sg ( SgA ) while removing,
      # and if B only connects to SgA.
      # Then B will be detached from SgA and then connects to DefaultSG
      # If this behaviour results in creating an SgLine between A & B.
      # Then the SgLine is actually connecting to an removing resource : A.
      # Currently the ComplexResModel can hanlde : after SgLine is created, A continues
      # to disconnect its connection, thus the newly created SgLine will be removed.
      # But this is a flaw of design of Connection, because I think it makes
      # ComplexResModel/ConnectionModel and its subclass strong coupling.
      # Maybe we could work out a better solution about this later.

      resource = @getOtherTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup )
      if resource.connections("SgAsso").length == 0
        defaultSg = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup ).getDefaultSg()
        if defaultSg
          new SgAsso( resource, defaultSg )
      null

    sortedSgList : ()->

      resource = @getOtherTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup )

      sgAssos = resource.connections("SgAsso")

      # Sort the SG
      sgs = _.map sgAssos, ( a )->
        a.getTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup )

      sgs.sort ( a_sg, b_sg )->
        if a_sg.isDefault() then return -1
        if b_sg.isDefault() then return 1

        a_nm = a_sg.get("name")
        b_nm = b_sg.get("name")

        if a_nm <  b_nm then return -1
        if a_nm == b_nm then return 0
        if a_nm >  b_nm then return 1


    # Drawing method, drawing method is used to update resource label
    updateLabel : ()->
      if not Design.instance().shouldDraw()
        return

      resource = @getOtherTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup )
      res_node = document.getElementById( resource.id )

      if not res_node then return

      sgs = @sortedSgList()

      # Update label
      for ch, idx in $(res_node).children(".node-sg-color-group").children()
        if idx < sgs.length
          CanvasManager.update( ch, sgs[idx].color, "color" )
          CanvasManager.update( ch, sgs[idx].get("name"), "tooltip" )

        else
          CanvasManager.update( ch, "none", "color" )
          CanvasManager.update( ch, "", "tooltip" )

      null
  }

  Design.on Design.EVENT.Deserialized, ()->
    # After the design is deserialized, we update all resource's label at once.
    updateMap = {}
    for asso in SgAsso.allObjects()
      updateMap[ asso.getOtherTarget( constant.AWS_RESOURCE_TYPE.AWS_EC2_SecurityGroup ).id ] = asso

    for resId, asso of updateMap
      asso.updateLabel()
    null

  SgAsso


