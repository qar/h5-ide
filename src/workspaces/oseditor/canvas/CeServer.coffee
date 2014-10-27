
define [
  "CanvasElement"
  "constant"
  "CanvasManager"
  "i18n!/nls/lang.js"
  "CloudResources"
  "./CpVolume"
], ( CanvasElement, constant, CanvasManager, lang, CloudResources, VolumePopup )->

  CanvasElement.extend {
    ### env:dev ###
    ClassName : "CeOsServer"
    ### env:dev:end ###
    type : constant.RESTYPE.OSSERVER

    parentType  : [ constant.RESTYPE.OSSUBNET ]
    defaultSize : [ 8, 8 ]

    portPosMap : {
      "pool"   : [ 5, 36, CanvasElement.constant.PORT_LEFT_ANGLE ]
      "server" : [ 82, 36, CanvasElement.constant.PORT_RIGHT_ANGLE, 85,36 ]
    }

    events :
      "mousedown .fip-status"   : "toggleFip"
      "mousedown .volume-image" : "showVolume"
      "click .volume-image"     : "suppressEvent"

    suppressEvent : ()-> false

    iconUrl : ()->
      image = @model.getImage() || @model.get("cachedAmi")

      if not image
        m = @model
        server = CloudResources( m.type, m.design().region() ).get( m.get("appId") )
        if server
          server = server.attributes
          if server.platform and server.platform is "windows"
            url = "ide/ami-os/windows.#{server.architecture}@2x.png"
          else
            url = "ide/ami-os/linux.#{server.architecture}@2x.png"
        else
          url = "ide/ami-os/image-not-available.png"
      else
        url = "ide/ami-os/#{image.os_type}.#{image.architecture}@2x.png"
      url

    listenModelEvents : ()->
      @listenTo @model, "change:imageId", @render
      @listenTo @model, 'change:fip', @render
      @listenTo @canvas, "change:externalData", @updateState
      return

    updateState: ->
      m = @model
      stateIcon  = @$el.children(".res-state")

      if stateIcon
        appData = CloudResources( m.type, m.design().region() ).get( m.get("appId") )
        state    = appData?.get("status") || "unknown"
        stateIcon.data("tooltip", state).attr("data-tooltip", state).attr("class", "res-state tooltip #{state}")

    toggleFip : ()->
      if @canvas.design.modeIsApp() then return false
      embedPort = @model.embedPort()
      hasFloatingIp = !!embedPort.getFloatingIp()
      embedPort.setFloatingIp(!hasFloatingIp)

      CanvasManager.updateFip @$el.children(".fip-status"), @model

      false


    # Creates a svg element
    create : ()->

      m = @model

      svg = @canvas.svg

      # Call parent's createNode to do basic creation
      svgEl = @createRawNode().add([

        svg.use("os_server")

        # Image Icon
        svg.image( MC.IMG_URL + @iconUrl(), 30, 30 ).move(25, 10).classes("ami-image tooltip")
        .attr('data-tooltip': @model.getImage().name)

        # FIP
        svg.group().move(43, 50).classes("fip-status tooltip").add([
          svg.image("").size(26,21).classes("normal")
          svg.image("").size(26,21).classes("hover")
        ])

        svg.image( MC.IMG_URL+ "ide/icon/icn-vol.png", 29, 24 ).move(22, 52).classes('volume-image')
        svg.text( "" ).move(36, 42).classes('volume-number')
        svg.use("port_diamond").attr({
          'class'        : 'port port-blue tooltip'
          'data-name'    : 'pool'
          'data-tooltip' : lang.IDE.PORT_TIP_O
        })
        svg.use("port_right").attr({
          'class'        : 'port port-green tooltip'
          'data-name'    : 'server'
          'data-tooltip' : lang.IDE.PORT_TIP_N
        })
      ])
      if not m.design().modeIsStack() and m.get("appId")
        svgEl.add( svg.circle(8).move(63, 15).classes('res-state unknown') )
      @canvas.appendNode svgEl
      @initNode svgEl, m.x(), m.y()
      @listenTo @model, 'change:volume', @updateVolume
      svgEl

    render : ()->
      m = @model
      # Update Label
      CanvasManager.setLabel @, @$el.children(".node-label")
      # Update Image
      CanvasManager.update @$el.children(".ami-image"), @iconUrl(), "href"
      # Update FIP
      CanvasManager.updateFip @$el.children(".fip-status"), m

      @updateVolume()
      @updateState()
      null

    updateVolume: ->
      m = @model
      volumes = m.volumes()
      @$el.children('.volume-number').find('tspan').text(volumes.length || 0)

    showVolume : ()->
      owner = @model

      v = owner.volumes()[0]
      attachment = @$el[0]
      canvas = @canvas

      new VolumePopup {
        attachment    : attachment
        host          : owner
        models        : owner.volumes()
        canvas        : canvas
        selectAtBegin : v
      }
      return
  }

