define [ "constant", "module/design/framework/canvasview/CanvasAdaptor", "CanvasManager" ], ( constant, CanvasAdaptor, CanvasManager ) ->

  ###
    -------------------------------
     Design is the main controller of the framework. It handles the input / ouput of the Application ( a.k.a the DesignCanvas ).
     The input and ouput is the same : the JSON data.
    -------------------------------


    ++ Class Method ++

    # instance() : Design
        description : returns the currently used Design object.


    ++ Object Method ++

    # component( uid ) : ResourceModel
        description : returns a resource model of uid

    # getAZ( azName ) : AzModel
        description : returns a AzModel, if the azModel doesn't exist, it will be created.

    # createConnection( p1U, p1N, p2U, p2N ) : ConnectionModel
        description : returns a ConnectionModel for the connection.

    # serialize() : Object
        description : returns a Plain JS Object that is indentical to JSON data.

    # serializeLayout() : Object
        description : returns a Plain JS Object that is indentical to Layout data.

  ###

  Design = ( json_data, layout_data, options )->

    design = (new DesignImpl( options )).use()
    design.canvas = new CanvasAdaptor( layout_data.size )

    json_data   = $.extend true, {}, json_data
    if layout_data.component
      layout_data = $.extend true, {}, layout_data.component.node, layout_data.component.group
    else
      layout_data = {}

    ###########################
    # Quick fix Boolean value in JSON, might removed latter
    ###########################
    Design.fixJson( json_data, layout_data )

    design.deserialize( json_data, layout_data )
    design


  _.extend( Design, Backbone.Events )
  Design.__modelClassMap   = {}
  Design.__resolveFirstMap = {}
  Design.__instance        = null

  # Inject dependency, so that CanvasManager/CanvasAdaptor won't require Design.js
  CanvasManager.setDesign( Design )
  CanvasAdaptor.setDesign( Design )


  DesignImpl = ( options )->
    @__componentMap = {}
    @__canvasNodes  = {}
    @__canvasLines  = {}
    @__canvasGroups = {}
    @__classCache   = {}
    @__type         = options.type
    @__mode         = options.mode
    @__region       = options.region

    # Disable drawing for deserializing, delay it until everything is deserialized
    @__shoulddraw   = false
    null


  Design.TYPE = {
    Classic    : "ec2-classic"
    Vpc        : "ec2-vpc"
    DefaultVpc : "default-vpc"
    CustomVpc  : "custom-vpc"
  }
  Design.MODE = {
    Stack   : "stack"
    App     : "app"
    AppEdit : "appedit"
    AppView : "appview"
  }


  DesignImpl.prototype.deserialize = ( json_data, layout_data )->

    that = @

    # A helper function to let each resource to get its dependency
    resolveDeserialize = ( uid )->

      if not uid then return null

      obj = that.__componentMap[ uid ]
      if obj then return obj

      # Check if we have recursive dependency
      console.assert (not recursiveCheck[uid] && recursiveCheck[uid] = true ), "Recursive dependency found when deserializing JSON_DATA"


      component_data = json_data[ uid ]

      ModelClass = Design.modelClassForType( component_data.type )
      if not ModelClass
        console.warn "We do not support deserializing resource of type : #{component_data.type}"
        return

      ModelClass.deserialize( component_data, layout_data[uid], resolveDeserialize )

      Design.__instance.__componentMap[ uid ]

    # Use resolve to replace component(), so that during deserialization,
    # dependency can be resolved by using design.component()
    _old_get_component_ = @component

    ###########################
    # Start deserialization
    # Deserialization cases :
    # subnets need mainRTB and defaultACL, mainRTB needs VPC.
    # Thus, there're 3 steps in the deserialization
    ###########################
    # Deserialize resolveFisrt resources
    @component = null # Forbid user to call component at this time.
    for uid, comp of json_data
      if Design.__resolveFirstMap[ comp.type ] is true
        ModelClass = Design.modelClassForType( comp.type )

        ### env:dev ###
        if not ModelClass
          console.warn "We do not support deserializing resource of type : #{component_data.type}"
          continue
        if not ModelClass.preDeserialize
          console.error "The class is marked as resolveFirst, yet it doesn't implement preDeserialize()"
          continue
        ### env:dev:end ###

        ModelClass.preDeserialize( comp, layout_data[uid] )


    # Deserialize normal resources
    @component = resolveDeserialize
    for uid, comp of json_data
      recursiveCheck = {}
      resolveDeserialize uid


    # Give a chance for resources to create connection between each others.
    @component = _old_get_component_
    for uid, comp of json_data
      ModelClass = Design.modelClassForType( comp.type )
      if ModelClass and ModelClass.postDeserialize
        ModelClass.postDeserialize( comp, layout_data[uid] )


    ####################
    # Draw after deserialization
    ####################
    # Draw everything after deserialization is done.
    # Because some resources might just deleted right after it's been created.
    # And draw lines at the end
    @__shoulddraw = true
    lines = []
    for uid, comp of @__componentMap
      if not comp.draw then continue
      if comp.node_line
        lines.push comp
      else
        comp.draw( true )

    for comp in lines
      comp.draw( true )


    ####################
    # Broadcast event
    ####################
    Design.trigger "deserialized"
    null

  ### Private Interface ###
  Design.registerModelClass = ( type, modelClass, resolveFirst )->
    @__modelClassMap[ type ] = modelClass
    if resolveFirst
      @__resolveFirstMap[ type ] = resolveFirst
    null

  DesignImpl.prototype.classCacheForCid = ( cid )->
    if @__classCache[ cid ]
      return @__classCache[ cid ]

    cache = @__classCache[ cid ] = []
    return cache

  DesignImpl.prototype.cacheComponent = ( id, comp )->
    if not comp
      delete @__componentMap[ id ]
      delete @__canvasGroups[ id ]
      delete @__canvasNodes[ id ]
    else
      @__componentMap[ id ] = comp

      # Cache them into another cache if they are visual objects
      if _.isFunction comp.draw
        if comp.node_group
          @__canvasGroups[ id ] = comp
        else if comp.node_line
          @__canvasLines[ id ] = comp
        else
          @__canvasNodes[ id ] = comp
    null


  Design.fixJson = ( data, layout_data )->

    azMap = {}
    azArr = []

    for uid, comp of layout_data
      if comp.type is "AWS.EC2.AvailabilityZone"
        azArr.push {
          uid  : uid
          type : "AWS.EC2.AvailabilityZone"
          name : comp.name
        }

        azMap[ comp.name ] = "@#{uid}.name"

    checkObj = ( obj )->
      for attr, d of obj
        if _.isString( d )
          if d is "true"
            obj[ attr ] = true
          else if d is "false"
            obj[ attr ] = false

          else if azMap[ d ] # Change azName to id
            obj[ attr ] = azMap[ d]

        else if _.isArray( d )
          for dd, idx in d
            if _.isObject( dd )
              checkObj( dd )
            if _.isString( dd )
              if d is "true"
                d[ idx ] = true
              else if d is "false"
                d[ idx ] = false

              else if azMap[ d ] # Change azName to id
                d[ idx ] = azMap[ d]

        else if _.isObject( d )
          checkObj( d )
      null

    for uid, comp of data
      checkObj( comp )

    for az in azArr
      data[ az.uid ] = az
    null

  ### env:dev ###
  Design.debug = ()->
    transform = ( a )->
      b = {}
      ignore = "|idAttribute|_pending|_changing|_previousAttributes|__design|validationError|node_group|node_line|changed|defaults|id|newNameTmpl"
      for att of a
        if _.isFunction( a[att] ) then continue
        if ignore.indexOf( "|" + att + "|" ) isnt -1 then continue

        if _.isArray( a[att] ) and a[att].length
          if a[att][0].isTypeof
            b[att] = []
            for x in a[att]
              b[att].push x.id
          else
            b[att] = $.extend( true, [], a[att] )
        else if _.isObject( a[att] ) and not _.isEmpty( a[att] )
          b[att] = $.extend( true, {}, a[att] )
        else
          b[att] = a[att]
      if b.attibutes and b.attributes.name then b.name = b.attibutes.name

      map = {}
      funcName = b.type.replace(/\./g, "_")
      ### jshint -W061 ###
      obj = eval( "(function #{funcName}( a ){ $.extend( true, this, a ); })" )
      ### jshint +W061 ###
      new obj( b )

    componentMap = Design.instance().__componentMap
    canvasNodes  = Design.instance().__canvasNodes
    canvasGroups = Design.instance().__canvasGroups
    checkedMap   = {
      "line"            : {}
      "node"            : {}
      "group"           : {}
      "otherResource"   : {}
      "otherConnection" : {}
    }
    checked = {}
    for id, a of canvasNodes
      checked[ id ] = true
      checkedMap.node[ a.id ] = transform( a )
    for id, a of canvasGroups
      checked[ id ] = true
      checkedMap.group[ a.id] = transform( a )
    for id, a of componentMap
      if checked[ id ] then continue
      if a.node_line
        if a.draw
          checkedMap.line[ a.id ] = transform( a )
        else
          checkedMap.otherConnection[ a.id ] = transform( a )
      else
        checkedMap.otherResource[ a.id ] = transform( a )

    checkedMap
  ### env:dev:end ###

  ### Private Interface End ###



  Design.instance = ()-> @__instance
  Design.modelClassForType = ( type )-> @__modelClassMap[ type ]

  DesignImpl.prototype.region = ()-> @.__region
  DesignImpl.prototype.mode   = ()->
    console.warn("Better not to use Design.instance().mode() directly.")
    this.__mode

  DesignImpl.prototype.type   = ()->
    console.warn("Better not to use Design.instance().type() directly.")
    this.__type


  DesignImpl.prototype.modeIsStack   = ()-> this.__mode == Design.MODE.Stack
  DesignImpl.prototype.modeIsApp     = ()-> this.__mode == Design.MODE.App
  DesignImpl.prototype.modeIsAppEdit = ()-> this.__mode == Design.MODE.AppEdit
  DesignImpl.prototype.setMode = (m)->
    this.__mode = m
    null

  DesignImpl.prototype.typeIsClassic    = ()-> this.__type == Design.TYPE.Classic
  DesignImpl.prototype.typeIsDefaultVpc = ()-> this.__type == Design.TYPE.DefaultVpc
  DesignImpl.prototype.typeIsVpc        = ()-> this.__type == Design.TYPE.Vpc or this.__type is Design.TYPE.CustomVpc

  DesignImpl.prototype.shouldDraw = ()-> @__shoulddraw
  DesignImpl.prototype.use = ()->
    Design.__instance = @
    @

  DesignImpl.prototype.component = ( uid )-> @__componentMap[ uid ]

  # DesignImpl.prototype.getAZ = ( azName, x, y , width, height )->
  #   AzModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_EC2_AvailabilityZone )

  #   allAzs = AzModel.allObjects()
  #   for az in allAzs
  #     if az.get("name") is azName
  #       return az

  #   # Retrieve AZ's layout info from layoutData
  #   if @groupLayoutData
  #     for uid, layout of @groupLayoutData
  #       if layout.type is constant.AWS_RESOURCE_TYPE.AWS_EC2_AvailabilityZone and layout.name is azName
  #         attr =
  #           id     : uid
  #           name   : azName
  #           x      : layout.coordinate[0]
  #           y      : layout.coordinate[1]
  #           width  : layout.size[0]
  #           height : layout.size[1]

  #   if not attr
  #     attr = {
  #       name   : azName
  #       x      : x
  #       y      : y
  #       width  : width
  #       height : height
  #     }

  #   new AzModel( attr )

  DesignImpl.prototype.serialize = ()->

    json_data   = {}

    connections = []
    mockArray   = []

    # ResourceModel can only add json component.
    for uid, comp of @__componentMap
      if comp.node_line
        connections.push comp
        continue

      json = comp.serialize()
      if not json
        continue

      # Make json to be an array
      if not _.isArray( json )
        mockArray[0] = json
        json = mockArray

      for j in json
        console.assert( j.uid, "Serialized JSON data has no uid." )
        console.assert( not json_data[ j.uid ], "ResourceModel cannot modify existing JSON data." )
        json_data[ j.uid ] = j

    # Connection
    for c in connections
      c.serialize( json_data )

    json_data


  DesignImpl.prototype.serializeLayout = ()->

  DesignImpl.prototype.createConnection = ( p1Uid, port1, p2Uid, port2 )->
    if port1 < port2
      p1Comp = @component( p1Uid )
      p2Comp = @component( p2Uid )
      type = port1 + "<" + port2
    else
      p1Comp = @component( p2Uid )
      p2Comp = @component( p1Uid )
      type = port2 + "<" + port1

    C = Design.modelClassForType( type )

    console.assert( C, "Cannot found Class for type: #{type}" )

    new C( p1Comp, p2Comp )

  Design
