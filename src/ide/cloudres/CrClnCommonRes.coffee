
define [
  "./CrCommonCollection"
  "./CrCollection"
  "./CrModel"
  "ApiRequest"
  "constant"
], ( CrCommonCollection, CrCollection, CrModel, ApiRequest, constant )->

  ### Elb ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrElbCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.ELB
    modelIdAttribute : "LoadBalancerName"

    parseFetchData : ( data )->
      elbs = data.DescribeLoadBalancersResponse.DescribeLoadBalancersResult.LoadBalancerDescriptions?.member
      for elb in elbs || []
        elb.AvailabilityZones = elb.AvailabilityZones?.member || []
        elb.Instances         = elb.Instances?.member || []
        elb.SecurityGroups    = elb.SecurityGroups?.member || []
        elb.Subnets           = elb.Subnets?.member || []
        for i, idx in elb.Instances
          elb.Instances[ idx ] = i.InstanceId
      elbs
  }

  ### VPN ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrVpnCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.VPN
    modelIdAttribute : "vpnConnectionId"
    parseFetchData : ( data )-> data.DescribeVpnConnectionsResponse.vpnConnectionSet?.item
  }

  ### EIP ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrEipCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.EIP
    modelIdAttribute : "allocationId"
    parseFetchData : ( data )-> data.DescribeAddressesResponse.addressesSet?.item
  }

  ### VPC ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrVpcCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.VPC
    modelIdAttribute : "vpcId"
    parseFetchData : ( data )-> data.DescribeVpcsResponse.vpcSet?.item
  }

  ### ASG ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrCloudWatchCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.ASG
    modelIdAttribute : "AutoScalingGroupARN"
    parseFetchData : ( data )->
      asgs = data.DescribeAutoScalingGroupsResponse.DescribeAutoScalingGroupsResult.AutoScalingGroups?.member
      for asg in asgs ||[]
        asg.AvailabilityZones   = asg.AvailabilityZones?.member || []
        asg.Instances           = asg.Instances?.member || []
        asg.TerminationPolicies = asg.TerminationPolicies?.member || []
      asgs
  }

  ### CloudWatch ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrAsgCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.CW
    parseFetchData : ( data )->
      cws = data.DescribeAlarmsResponse.DescribeAlarmsResult.MetricAlarms?.member
      for cw in cws || []
        cw.Dimensions = cw.Dimensions?.member || []
        cw.id = cw.AlarmArn
        delete cw.AlarmArn
      cws
  }

  ### CGW ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrCgwCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.CGW
    modelIdAttribute : "customerGatewayId"
    parseFetchData : ( data )-> data.DescribeCustomerGatewaysResponse.customerGatewaySet?.item
  }

  ### VGW ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrVgwCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.VGW
    modelIdAttribute : "vpnGatewayId"
    parseFetchData : ( data )-> data.DescribeVpnGatewaysResponse.vpnGatewaySet?.item
  }

  ### IGW ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrIgwCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.IGW
    modelIdAttribute : "internetGatewayId"
    parseFetchData : ( data )->
      igws = data.DescribeInternetGatewaysResponse.internetGatewaySet?.item
      for igw in igws || []
        igw.attachmentSet = igw.attachmentSet?.item || []
        igw.id = igw.internetGatewayId
        delete igw.internetGatewayId
      igws
  }

  ### RTB ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrRtbCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.RT
    parseFetchData : ( data )->
      rtbs = data.DescribeRouteTablesResponse.routeTableSet?.item
      for rtb in rtbs || []
        rtb.routeSet = rtb.routeSet?.item || []
        rtb.associationSet = rtb.associationSet?.item || []
        rtb.id = rtb.routeTableId
        delete rtb.routeTableId
      rtbs
  }

  ### INSTANCE ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrInstanceCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.INSTANCE
    parseFetchData : ( data )->
      itemset = data.DescribeInstancesResponse.reservationSet
      if not itemset then return

      instances = []
      for i in itemset.item
        try
          for ami in i.instancesSet.item
            ami.blockDeviceMapping  = ami.blockDeviceMapping?.item || []
            ami.networkInterfaceSet = ami.networkInterfaceSet?.item || []
            ami.groupSet            = ami.groupSet?.item || []

            ami.id = ami.instanceId
            delete ami.instanceId
            instances.push ami
        catch e
          console.error "Fail to parse instance data", i

      instances
  }

  ### VOLUME ###
  CrCommonCollection.extend {
    ### env:dev ###
    ClassName : "CrVolumeCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.VOL
    parseFetchData : ( data )->
      volumes = data.DescribeVolumesResponse.volumeSet?.item
      for vol in volumes || []
        vol.id = vol.volumeId
        delete vol.volumeId
        vol.attachmentSet = vol.attachmentSet?.item || []
      volumes
  }

  ### SUBNET ###
  CrCollection.extend {
    ### env:dev ###
    ClassName : "CrSubnetCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.SUBNET
    modelIdAttribute : "subnetId"
    doFetch : ()-> ApiRequest("subnet_DescribeSubnets", {region_name : @region()})
    parseFetchData : ( data )-> data.DescribeSubnetsResponse.subnetSet?.item
  }

  ### SG ###
  CrCollection.extend {
    ### env:dev ###
    ClassName : "CrSgCollection"
    ### env:dev:end ###

    type  : constant.RESTYPE.SG
    doFetch : ()-> ApiRequest("sg_DescribeSecurityGroups", {region_name : @region()})
    parseFetchData : ( data )->
      sgs = data.DescribeSecurityGroupsResponse.securityGroupInfo?.item
      for sg in sgs || []
        sg.ipPermissions       = sg.ipPermissions?.item || []
        sg.ipPermissionsEgress = sg.ipPermissionsEgress?.item || []
        sg.id = sg.groupId
        delete sg.groupId
      sgs
  }

