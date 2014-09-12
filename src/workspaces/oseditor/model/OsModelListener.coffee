
define [ "ComplexResModel", "constant", "Design" ], ( ComplexResModel, constant, Design )->

  Model = ComplexResModel.extend {

    type : constant.RESTYPE.OSLISTENER
    newNameTmpl : "Listener-"

    defaults:
      protocol: 'HTTP'
      port: 80
      adminStateUp: ''
      limit: 1000

    serialize : ()->
      component =
        name : @get 'name'
        type : @type
        uid  : @id
        resource :
          id                : @get 'appId'
          name              : @get 'name'
          pool_id           : @connectionTargets( 'OsListenerAsso' )[ 0 ].createRef 'id'
          connection_limit  : @get 'limit'
          protocol          : @get 'protocol'
          protocol_port     : @get 'port'
          admin_state_up    : @get 'adminStateUp'


      { component : component }

  }, {

    handleTypes  : constant.RESTYPE.OSLISTENER

    deserialize : ( data, layout_data, resolve )->
      listener = new Model({
        id            : data.uid
        name          : data.resource.name
        appId         : data.resource.id

        limit         : data.resource.connection_limit
        port          : data.resource.protocol_port
        protocol      : data.resource.protocol
        adminStateUp  : data.resource.admin_state_up

        parent        : resolve( MC.extractID( data.resource.subnet_id ) )
        x             : layout_data.coordinate[0]
        y             : layout_data.coordinate[1]
      })

      Asso = Design.modelClassForType( "OsListenerAsso" )
      new Asso( listener, resolve(MC.extractID( data.resource.pool_id )) )
      return
  }

  Model
