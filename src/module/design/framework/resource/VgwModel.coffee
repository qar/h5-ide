
define [ "../ComplexResModel", "./VpcModel", "Design", "constant" ], ( ComplexResModel, VpcModel, Design, constant )->

  Model = ComplexResModel.extend {

    defaults :
      x        : 0
      y        : 0
      width    : 8
      height   : 8
      name     : "VPN-gateway"

    type : constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway

    initialize : ()->
      VpcModel.theVPC().addChild( this )

      @draw(true)
      null

    serialize : ()->

      layout =
        size       : [ @width(), @height() ]
        coordinate : [ @x(), @y() ]
        uid        : @id
        groupUId   : @parent().id

      component =
        name : @get("name")
        type : @type
        uid  : @id
        resource :
          State            : "available"
          Type             : "ipsec.1"
          VpnGatewayId     : @get("appId")
          AvailabilityZone : ""
          Attachments      : [{
            State : "attached"
            VpcId : @parent().createRef( "VpcId" )
          }]

      { component : component, layout : layout }

  }, {

    handleTypes : constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway

    deserialize : ( data, layout_data, resolve )->

      new Model({

        id    : data.uid
        name  : data.name
        appId : data.resource.VpnGatewayId

        x : layout_data.coordinate[0]
        y : layout_data.coordinate[1]
      })

      null

  }

  Model

