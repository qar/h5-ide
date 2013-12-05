define [ "constant" ], ( constant ) ->

  ###
    -------------------------------
     Design is the main controller of the framework. It handles the input / ouput of the Application ( a.k.a the DesignCanvas ).
     The input and ouput is the same : the JSON data.
    -------------------------------


    ++ Class Method ++

    # instance() : Design
        description : returns the currently used Design object.


    ++ Object Method ++

    # getComponent( uid ) : ResourceModel
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

  design_instance = null



  Design = ( json_data, layout_data, options )->

    design = (new DesignImpl( options )).use()

    # Temporarily set layout_data in design, so that getAZ can use it
    design.groupLayoutData = layout_data.component.group

    layout_data = $.extend {}, layout_data.component.node, layout_data.component.group

    # Deserialize

    # A helper function to let each resource to get its dependency
    resolveDeserialize = ( uid )->

      obj = design_instance.getComponent( uid )
      if obj
        return obj

      # Check if we have recursive dependency
      console.assert (not recursiveCheck[uid] && recursiveCheck[uid] = true ), "Recursive dependency found when deserializing JSON_DATA"



      component_data = json_data[ uid ]

      ModelClass = Design.modelClassForType( component_data.type )
      if not ModelClass
        console.warn "We do not support deserializing resource of type : #{component_data.type}"
        return

      ModelClass.deserialize( component_data, layout_data[uid], resolveDeserialize )

      design_instance.getComponent( uid )


    for uid, comp of json_data
      recursiveCheck = {}
      resolveDeserialize uid

    delete design.groupLayoutData

    design

  DesignImpl = ( options )->
    @__componentMap = {}
    @__canvasNodes  = {}
    @__canvasGroups = {}
    @__classCache   = {}
    @__type         = options.type
    @__mode         = options.mode
    null


  Design.TYPE = {
    Classic    : "Classic"
    Vpc        : "Vpc"
    DefaultVpc : "DefaultVpc"
  }
  Design.MODE = {
    Stack   : "Stack"
    App     : "App"
    AppEdit : "AppEdit"
  }

  ### Private Interface ###
  Design.__modelClassMap = {}
  Design.registerModelClass = ( type, modelClass )->
    @__modelClassMap[ type ] = modelClass
    null

  Design.modelClassForType = ( type )-> @__modelClassMap[ type ]

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
        if comp.get("group")
          @__canvasGroups[ id ] = comp
        else
          @__canvasNodes[ id ] = comp
    null
  ### Private Interface End ###


  Design.instance = ()-> design_instance


  DesignImpl.prototype.mode          = ()-> this.__mode
  DesignImpl.prototype.modeIsStack   = ()-> this.__mode == Design.MODE.Stack
  DesignImpl.prototype.modeIsApp     = ()-> this.__mode == Design.MODE.App
  DesignImpl.prototype.modeIsAppEdit = ()-> this.__mode == Design.MODE.AppEdit
  DesignImpl.prototype.setMode = (m)->
    this.__mode = m
    null

  DesignImpl.prototype.type             = ()-> this.__type
  DesignImpl.prototype.typeIsClassic    = ()-> this.__type == Design.TYPE.Classic
  DesignImpl.prototype.typeIsDefaultVpc = ()-> this.__type == Design.TYPE.DefaultVpc
  DesignImpl.prototype.typeIsVpc        = ()-> this.__type == Design.TYPE.Vpc


  DesignImpl.prototype.shouldDraw = ()-> true

  DesignImpl.prototype.use = ()->
    window.DesignInst = design_instance = @
    @

  DesignImpl.prototype.getComponent = ( uid )-> @__componentMap[ uid ]

  DesignImpl.prototype.node  = ()-> _.extend {},  @__canvasNodes
  DesignImpl.prototype.group = ()-> _.extend {},  @__canvasGroups

  DesignImpl.prototype.getAZ = ( azName, x, y , width, height )->
    AzModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_EC2_AvailabilityZone )

    allAzs = AzModel.allObjects()
    for az in allAzs
      if az.get("name") is azName
        return az

    # Retrieve AZ's layout info from layoutData
    if @groupLayoutData
      for uid, layout of @groupLayoutData
        if layout.type is constant.AWS_RESOURCE_TYPE.AWS_EC2_AvailabilityZone and layout.name is azName
          attr =
            id     : uid
            name   : azName
            x      : layout.coordinate[0]
            y      : layout.coordinate[1]
            width  : layout.size[0]
            height : layout.size[1]

    if not attr
      attr = {
        name   : azName
        x      : x
        y      : y
        width  : width
        height : height
      }

    new AzModel( attr )

  DesignImpl.prototype.serialize = ()->

    json_data   = {}

    connections = []
    mockArray   = []

    # ResourceModel can only add json component.
    for uid, comp of @__componentMap
      if comp.isConnection and comp.isConnection()
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

  Design
