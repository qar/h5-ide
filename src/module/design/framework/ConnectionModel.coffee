
define [ "./ResourceModel", "Design", "./CanvasManager" ], ( ResourceModel, Design, CanvasManager )->

  ###
    -------------------------------
     ConnectionModel is the base class to implment a connection between two resources
    -------------------------------

    ++ Object Method ++

    port1()
    port2()
      description : returns the name of the port, port1() is always smaller than port2()

    port1Comp()
    port2Comp()
      description : returns the component of each port

    getTarget : ( type )
      description : returns a component of a specific type

    getOtherTarget : ( theType )
      description : returns a component that its type is not of theType

    connectsTo : ( id )
      description : returns true if this connection connects to resource of id

    remove()
      description : remove the connection from two resources.
  ###

  ConnectionModel = ResourceModel.extend {

    defaults :
      connection : true

    type : "Framework_CN"

    constructor : ( p1Comp, p2Comp, attr ) ->

      if @portDefs

        for def in @portDefs
          if def.port1.type is p1Comp.type and def.port2.type is p2Comp.type
            @__portDef   = def
            @__port1Comp = p1Comp
            @__port2Comp = p2Comp
            break
          else if def.port1.type is p2Comp.type and def.port2.type is p1Comp.type
            @__portDef   = def
            @__port1Comp = p2Comp
            @__port2Comp = p1Comp
            break

        console.assert( @__portDef, "Cannot create connection!" )

      else
        # If there's no portDefs, we directly assign the parameter to this
        @__port1Comp = p1Comp
        @__port2Comp = p2Comp


      # Call super constructor
      ResourceModel.call(this, attr)

      if @get("visual") isnt false and @portDefs
        # If we have portDefs, then it's considered to be visual line
        # But the subclass can also set visual to false,
        # to indicate this is not a visual line.
        CanvasManager.drawLine( this )

      # Put connect() calls to last, in case of some resource might want the Line SVG Node
      @__port1Comp.connect this
      @__port2Comp.connect this

      this

    port1 : ( attr )->
      if @__portDef then @__portDef.port1[ attr ] else ""
    port2 : ( attr )->
      if @__portDef then @__portDef.port2[ attr ] else ""

    connectsTo : ( id )->
      ( @__port1Comp && @__port1Comp.id is id ) or ( @__port2Comp && @__port2Comp.id is id )

    port1Comp : ()-> @__port1Comp
    port2Comp : ()-> @__port2Comp

    getOtherTarget : ( type )->
      if @__port1Comp.type isnt type
        return @__port1Comp

      return @__port2Comp

    getTarget : ( type )->
      if @__port1Comp.type is type
        return @__port1Comp

      if @__port2Comp.type is type
        return @__port2Comp

      null

    remove : ()->

      # Directly remove the connection without triggering anything.
      c = @__port1Comp.attributes.__connections
      ci = c.indexOf this
      if ci != -1
        c.splice( ci, 1 )

      c = @__port2Comp.attributes.__connections
      ci = c.indexOf this
      if ci != -1
        c.splice( ci, 1 )

      null
  }, {
    extend : ( protoProps, staticProps )->

      if protoProps.portDefs and not _.isArray( protoProps.portDefs )
        protoProps.portDefs = [ protoProps.portDefs ]

      tags = []

      # Ensure port1 is always smaller than port2
      for def in protoProps.portDefs
        if def.port1.name > def.port2.name
          tmp = def.port1
          def.port1 = def.port2
          def.port2 = tmp

        tags.push def.port1.name + ">" + def.port2.name

      if not protoProps.type
        protoProps.type = tags[0]

      child = ResourceModel.extend.call( this, protoProps, staticProps )

      for t in tags
        Design.registerModelClass t, child

      child
  }

  ConnectionModel

