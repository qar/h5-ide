
define [ "constant", "../ConnectionModel" ], ( constant, ConnectionModel )->

  C = ConnectionModel.extend {

    type : "RTB_Route"

    defaults : ()->
      lineType : "rtb-target"
      dashLine : true
      routes   : []

    initialize : ( attr, option )->
      igw = @getTarget( constant.AWS_RESOURCE_TYPE.AWS_VPC_InternetGateway )

      if igw and not attr.routes
        # By default add an "0.0.0.0/0" route for IGW
        @get("routes").push "0.0.0.0/0"
      null

    addRoute : ( route )->
      routes = @get("routes")

      idx = _.indexOf routes, route

      if idx != -1 then return false

      routes.push route
      @set "routes", routes
      true

    removeRoute : ( route )->
      routes = @get("routes")

      idx = _.indexOf routes, route

      if idx != -1 then return false

      routes.splice idx, 1
      @set "routes", routes
      true

    setPropagate : ( propagate )->
      console.assert( (@port1Comp().type is constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway) or (@port2Comp().type is constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway), "Propagation can only be set to VPN<==>RTB connection." )

      @set "propagate", propagate

    serialize : ( components )->
      rtb = @getTarget( constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable )
      otherTarget = @getOtherTarget( rtb )

      rtb_data = components[ rtb.id ]

      if @get("propagate")
        rtb_data.resource.PropagatingVgwSet.push otherTarget.createRef( "VpnGatewayId" )

      r_temp = {
        Origin : ""
        InstanceId : ""
        NetworkInterfaceId : ""
        State : ""
        GatewayId : ""
        InstanceOwnerId : ""
      }

      TYPE = constant.AWS_RESOURCE_TYPE

      switch otherTarget.type
        when TYPE.AWS_VPC_NetworkInterface
          r_temp.NetworkInterfaceId = otherTarget.createRef( "NetworkInterfaceId" )

        when TYPE.AWS_VPC_InternetGateway
          r_temp.GatewayId = otherTarget.createRef( "InternetGatewayId" )

        when TYPE.AWS_VPC_VPNGateway
          r_temp.GatewayId = otherTarget.createRef( "VpnGatewayId" )

        when TYPE.AWS_EC2_Instance
          r_temp.NetworkInterfaceId = otherTarget.getEmbedEni().createRef( "NetworkInterfaceId" )

      for r in @get("routes")
        d = { "DestinationCidrBlock" : r }
        rtb_data.resource.RouteSet.push $.extend( d, r_temp )

      null

    portDefs : [
      {
        port1 :
          name : "igw-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_InternetGateway
        port2 :
          name : "rtb-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "instance-rtb"
          type : constant.AWS_RESOURCE_TYPE.AWS_EC2_Instance
        port2 :
          name : "rtb-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "eni-rtb"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_NetworkInterface
        port2 :
          name : "rtb-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "vgw-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway
        port2 :
          name : "rtb-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
    ]


  }

  C
