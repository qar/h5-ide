
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

    portDefs : [
      {
        port1 :
          name : "igw-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_InternetGateway
        port2 :
          name      : "rtb-tgt"
          direction : "horizontal"
          type      : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "instance-rtb"
          type : constant.AWS_RESOURCE_TYPE.AWS_EC2_Instance
        port2 :
          name      : "rtb-tgt"
          direction : "horizontal"
          type      : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "eni-rtb"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_NetworkInterface
        port2 :
          name      : "rtb-tgt"
          direction : "horizontal"
          type      : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
      {
        port1 :
          name : "vgw-tgt"
          type : constant.AWS_RESOURCE_TYPE.AWS_VPC_VPNGateway
        port2 :
          name      : "rtb-tgt"
          direction : "horizontal"
          type      : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
      }
    ]


  }

  C
