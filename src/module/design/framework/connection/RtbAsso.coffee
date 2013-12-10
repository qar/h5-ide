
define [ "constant", "../ConnectionModel" ], ( constant, ConnectionModel )->

  C = ConnectionModel.extend {

    type : "RTB_Asso"

    defaults :
      lineType : "association"
      implicit : false

    portDefs :
      port1 :
        name : "subnet-assoc-out"
        type : constant.AWS_RESOURCE_TYPE.AWS_VPC_Subnet
      port2 :
        name      : "rtb-src"
        direction : "vertical"
        type      : constant.AWS_RESOURCE_TYPE.AWS_VPC_RouteTable
  }

  C
