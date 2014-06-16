
define [ "./CanvasElement", "./CeInstance", "constant", "CanvasManager", 'i18n!nls/lang.js', "CloudResources" ], ( CanvasElement, CeInstance, constant, CanvasManager, lang, CloudResources )->

  CeLc = ()->
    CanvasElement.apply( this, arguments )
    @asg = @model.getAsg()
    @lc = @model.getLc()
    @

  CanvasElement.extend.call( CeInstance, CeLc, 'Lc_Asso')
  ChildElementProto = CeLc.prototype

  ###
  # Child Element's interface.
  ###
  ChildElementProto.portPosMap = {
    "launchconfig-sg-left"  : [ 10, 20, CanvasElement.constant.PORT_LEFT_ANGLE ]
    "launchconfig-sg-right" : [ 80, 20, CanvasElement.constant.PORT_RIGHT_ANGLE ]
  }
  ChildElementProto.portDirMap = {
    "launchconfig-sg" : "horizontal"
  }

  ChildElementProto.detach = ()->
    # Remove state icon
    MC.canvas.nodeAction.remove @id
    CanvasElement.prototype.detach.call this
    null

  ChildElementProto.list = ()->
    list = CanvasElement.prototype.list.call(this)
    for ins in list
      ins.background = @iconUrl( ins.appId )
    list.volume = (@lc.get("volumeList") || []).length
    list

  ChildElementProto.iconUrl = ( instanceId )->

    if instanceId
      region = Design.instance().region()
      ami = CloudResources( constant.RESTYPE.INSTANCE, region ).get(instanceId)
      if ami then ami = CloudResources( constant.RESTYPE.AMI, region ).get( ami.imageId )?.attributes

    if not ami
      ami = @lc.getAmi() || @lc.get("cachedAmi")

    if not ami
      "ide/ami/ami-not-available.png"
    else
      "ide/ami/#{ami.osType}.#{ami.architecture}.#{ami.rootDeviceType}.png"

  ChildElementProto.draw = ( isCreate )->

    m = @model

    if isCreate

      # Call parent's createNode to do basic creation
      node = @createNode({
        id      : m.id
        image   : "ide/icon/instance-canvas.png"
        imageX  : 15
        imageY  : 9
        imageW  : 61
        imageH  : 62
        label   : MC.truncate @lc.get('name'), 15
        labelBg : true
        sg      : true
        class   : 'AWS-AutoScaling-LaunchConfiguration'
      })

      # Insert Volume / Eip / Port
      node.append(
        # Ami Icon
        Canvon.image( MC.IMG_URL + @iconUrl(), 30, 15, 39, 27 ).attr({'class':"ami-image"}),

        # Volume Image
        Canvon.image( "" , 31, 44, 29, 24 ).attr({
            'id': "#{@id}_volume_status"
            'class':'volume-image'
          }),
        # Volume Label
        Canvon.text( 45, 56, "" ).attr({'class':'node-label volume-number'}),

        # Volume Hotspot
        Canvon.rectangle(31, 44, 29, 24).attr({
          'data-target-id' : @id
          'class'          : 'instance-volume'
          'fill'           : 'none'
        }),

        # left port(blue)
        Canvon.path(this.constant.PATH_PORT_DIAMOND).attr({
          'class' : 'port port-blue port-launchconfig-sg port-launchconfig-sg-left tooltip'
          'data-name'      : 'launchconfig-sg'
          'data-alias'     : 'launchconfig-sg-left'
          'data-position'  : 'left'
          'data-type'      : 'sg'
          'data-direction' : 'in'
          'data-tooltip'   : lang.ide.PORT_TIP_D
        }),

        # right port(blue)
        Canvon.path(this.constant.PATH_PORT_DIAMOND).attr({
          'class' : 'port port-blue port-launchconfig-sg port-launchconfig-sg-right tooltip'
          'data-name'      : 'launchconfig-sg'
          'data-alias'     : 'launchconfig-sg-right'
          'data-position'  : 'right'
          'data-type'      : 'sg'
          'data-direction' : 'out'
          'data-tooltip'   : lang.ide.PORT_TIP_D
        })

        # Child number
        Canvon.group().append(
          Canvon.rectangle(36, 1, 20, 16).attr({'class':'server-number-bg','rx':4,'ry':4}),
          Canvon.text(46, 13, "0").attr({'class':'node-label server-number'})
        ).attr({
          'id'      : "#{@id}_instance-number-group"
          'class'   : 'instance-number-group'
          "display" : "none"
        })
      )

      @getLayer("node_layer").append node

      @initNode node, m.x(), m.y()

    else
      node = @$element @lc.id

      # Node Label
      CanvasManager.update node.children(".node-label-name"), MC.truncate @lc.get('name'), 15

    # Update Ami Image
    CanvasManager.update node.children(".ami-image"), @iconUrl(), "href"

    # Volume Number
    volumeCount = (@lc.get("volumeList") || []).length
    CanvasManager.update node.children(".volume-number"), volumeCount
    if volumeCount > 0
      volumeImage = 'ide/icon/instance-volume-attached-normal.png'
    else
      volumeImage = 'ide/icon/instance-volume-not-attached.png'
    CanvasManager.update node.children(".volume-image"), volumeImage, "href"


    # In app mode, show number
    if not @lc.design().modeIsStack() and @asg
      data = CloudResources(@asg.type, @lc.design().region()).get(@asg.get('appId'))?.attributes
      numberGroup = node.children(".instance-number-group")
      if data and data.Instances and data.Instances.member and data.Instances.member.length > 0
        CanvasManager.toggle numberGroup, true
        CanvasManager.update numberGroup.children("text"), data.Instances.member.length
      else
        CanvasManager.toggle numberGroup, false
    null


  ChildElementProto.select = ( subId )->

    if subId
      type = constant.RESTYPE.INSTANCE
    else
      type = @lc.type

    @doSelect( type, subId or @id, @id )

  ChildElementProto.position = ( x, y )->

    oldx = @model.x()
    oldy = @model.y()

    if (x is undefined or x is null) and (y is undefined or y is null)
      return [ oldx, oldy ]

    x = @model.x()
    y = @model.y()

    el = @element()
    if el
      MC.canvas.position( el, x, y )
    null

  null

  ChildElementProto.isRemovable = ->
    if @lc.getUsage().length is 1
      lcName = @lc.get('name')
      asgName = @asg.get('name')
      return sprintf lang.ide.CVS_CFM_DEL_LC, lcName, asgName, asgName, lcName

    true


