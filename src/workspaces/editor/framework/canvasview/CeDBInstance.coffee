
define [ "i18n!/nls/lang.js", "./CanvasElement", "constant", "CanvasManager", "Design", "CloudResources" ], ( lang, CanvasElement, constant, CanvasManager, Design, CloudResources )->

  CeDBInstance = ()-> CanvasElement.apply( this, arguments )
  CanvasElement.extend( CeDBInstance, constant.RESTYPE.DBINSTANCE )
  ChildElementProto = CeDBInstance.prototype



  ChildElementProto.draw = ( isCreate )->
    m = @model

    if isCreate

      # Call parent's createNode to do basic creation
      node = @createNode({
        image   : "ide/icon/instance-canvas.png"
        imageX  : 15
        imageY  : 9
        imageW  : 61
        imageH  : 62
        label   : m.get("name")
        labelBg : true
        sg      : true
      })

      # Insert Volume / Eip / Port
      node.append(
        # Ami Icon
        Canvon.image( MC.IMG_URL + @iconUrl(), 30, 15, 39, 27 ).attr({'class':"ami-image"}),

        # Volume Image
        Canvon.image( "", 21, 44, 29, 24 ).attr({
          'id'    : "#{@id}_volume_status"
          'class' : 'volume-image'
        }),
        # Volume Label
        Canvon.text( 35, 56, "" ).attr({'class':'node-label volume-number'}),
        # Volume Hotspot
        Canvon.rectangle(21, 44, 29, 24).attr({
          'data-target-id' : @id
          'class'          : 'instance-volume'
          'fill'           : 'none'
        }),

        # Eip
        Canvon.image( "", 53, 47, 12, 14).attr({'class':'eip-status tooltip'}),

        # Child number
        Canvon.group().append(
          Canvon.rectangle(36, 1, 20, 16).attr({'class':'server-number-bg','rx':4,'ry':4}),
          Canvon.text(46, 13, "0").attr({'class':'node-label server-number'})
        ).attr({
          'id'      : "#{@id}_instance-number-group"
          'class'   : 'instance-number-group'
          "display" : "none"
        }),


        # left port(blue)
        Canvon.path(this.constant.PATH_PORT_DIAMOND).attr({
          'class'          : 'port port-blue port-instance-sg port-instance-sg-left tooltip'
          'data-name'      : 'instance-sg' #for identify port
          'data-alias'     : 'instance-sg-left'
          'data-position'  : 'left' #port position: for calc point of junction
          'data-type'      : 'sg'   #color of line
          'data-direction' : 'in'   #direction
          'data-tooltip'   : lang.ide.PORT_TIP_D
        }),

        # right port(blue)
        Canvon.path(this.constant.PATH_PORT_DIAMOND).attr({
          'class'          : 'port port-blue port-instance-sg port-instance-sg-right tooltip'
          'data-name'      : 'instance-sg'
          'data-alias'     : 'instance-sg-right'
          'data-position'  : 'right'
          'data-type'      : 'sg'
          'data-direction' : 'out'
          'data-tooltip'   : lang.ide.PORT_TIP_D
        })

        # RTB/ENI Port
        Canvon.path(this.constant.PATH_PORT_RIGHT).attr({
            'class'      : 'port port-green port-instance-attach tooltip'
            'data-name'     : 'instance-attach'
            'data-position' : 'right'
            'data-type'     : 'attachment'
            'data-direction': 'out'
            'data-tooltip'  : lang.ide.PORT_TIP_E
        })

        Canvon.path(this.constant.PATH_PORT_BOTTOM).attr({
            'class'      : 'port port-blue port-instance-rtb tooltip'
            'data-name'     : 'instance-rtb'
            'data-position' : 'top'
            'data-type'     : 'sg'
            'data-direction': 'in'
            'data-tooltip'  : lang.ide.PORT_TIP_C
        })
      )

      if not @model.design().modeIsStack() and m.get("appId")
        # instance-state
        node.append(
          Canvon.circle(68, 15, 5,{}).attr({
            'id'    : "#{@id}_instance-state"
            'class' : 'instance-state instance-state-unknown'
          })
        )

      # Move the node to right place
      @getLayer("node_layer").append node
      @initNode node, m.x(), m.y()

    else
      node = @$element()
      # update label
      CanvasManager.update node.children(".node-label-name"), m.get("name")

    if not @model.design().modeIsStack() and m.get("appId")
      # Update Instance State in app
      @updateAppState()

    # Update Ami Image
    CanvasManager.update node.children(".ami-image"), @iconUrl(), "href"


    # Update Server number
    numberGroup = node.children(".instance-number-group")
    if m.get("count") > 1
      CanvasManager.toggle node.children(".instance-state"), false
      CanvasManager.toggle node.children(".port-instance-rtb"), false
      CanvasManager.toggle numberGroup, true
      CanvasManager.update numberGroup.children("text"), m.get("count")
    else
      CanvasManager.toggle node.children(".instance-state"), true
      CanvasManager.toggle node.children(".port-instance-rtb"), true
      CanvasManager.toggle numberGroup, false


    # Update Volume
    volumeCount = if m.get("volumeList") then m.get("volumeList").length else 0
    if volumeCount > 0
      volumeImage = 'ide/icon/instance-volume-attached-normal.png'
    else
      volumeImage = 'ide/icon/instance-volume-not-attached.png'
    CanvasManager.update node.children(".volume-image"), volumeImage, "href"
    CanvasManager.update node.children(".volume-number"), volumeCount

    # Update EIP
    CanvasManager.updateEip node.children(".eip-status"), m

    null




  CeDBInstance
