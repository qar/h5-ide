#############################
#  View Mode for design/property/instance
#############################

define [ '../base/model', 'keypair_model', 'constant' ], ( PropertyModel, keypair_model, constant ) ->

  EbsMap =
    "m1.large"   : true
    "m1.xlarge"  : true
    "m2.2xlarge" : true
    "m2.4xlarge" : true
    "m3.xlarge"  : true
    "m3.2xlarge" : true
    "c1.xlarge"  : true

  LaunchConfigModel = PropertyModel.extend {

    setup : ->
      me = this
      this.on 'EC2_KPDOWNLOAD_RETURN', ( result )->

        region_name = result.param[3]
        keypairname = result.param[4]

        curr_keypairname = me.get("lc")

        # The user has closed the dialog
        # Do nothing
        if curr_keypairname.KeyName isnt keypairname
            return

        ###
        # The EC2_KPDOWNLOAD_RETURN event won't fire when the result.is_error
        # is true. According to bugs in service models.
        ###

        me.trigger "KP_DOWNLOADED", result.resolved_data

        null


    downloadKP : ( keypairname ) ->
        username = $.cookie "usercode"
        session  = $.cookie "session_id"

        keypair_model.download {sender:@}, username, session, MC.canvas_data.region, keypairname
        null


    init  : ( uid ) ->

      if @isApp
        @getAppLaunch( uid )
      else
        component = MC.canvas_data.component[ uid ]
        data = {
          uid      : uid
          userData : component.resource.UserData
          name     : component.name
          imageId  : component.resource.ImageId
        }
        @getCheckBox( uid, data )
        @getKeyPair( uid, data )
        @getInstanceType( uid, data )
        @getAmi( uid, data )

        this.set data

      null

    setName  : ( name ) ->
      uid = this.get 'uid'
      MC.canvas_data.component[ uid ].name = name
      MC.canvas.update(uid,'text','lc_name', name)

      # update lc in extended asg
      asg_uid = MC.canvas_data.layout.component.node[ uid ].groupUId

      _.each MC.canvas_data.layout.component.group, ( group, id ) ->
        if group.originalId is asg_uid
          MC.canvas.update id, 'text', 'node-label', name
      null

    setInstanceType  : ( value ) ->
      uid = this.get 'uid'
      component = MC.canvas_data.component[ uid ]

      component.resource.InstanceType = value

      has_ebs = EbsMap.hasOwnProperty value
      if not has_ebs
        component.resource.EbsOptimized = "false"

      has_ebs

    setEbsOptimized : ( value )->
      uid = this.get 'uid'
      MC.canvas_data.component[ uid ].resource.EbsOptimized = value
      null

    setCloudWatch : ( value ) ->

      uid = this.get 'uid'
      MC.canvas_data.component[ uid ].resource.InstanceMonitoring = if value then 'enabled' else 'disabled'
      null

    setUserData : ( value ) ->

      uid = this.get 'uid'
      MC.canvas_data.component[ uid ].resource.UserData = value
      null

    unAssignSGToComp : (sg_uid) ->

      lcUID = this.get 'uid'

      originSGIdAry = MC.canvas_data.component[lcUID].resource.SecurityGroups

      currentSGId = '@' + sg_uid + '.resource.GroupId'

      originSGIdAry = _.filter originSGIdAry, (value) ->
        value isnt currentSGId

      MC.canvas_data.component[lcUID].resource.SecurityGroups = originSGIdAry


      null

    assignSGToComp : (sg_uid) ->

      instanceUID = this.get 'uid'

      originSGIdAry = MC.canvas_data.component[instanceUID].resource.SecurityGroups

      currentSGId = '@' + sg_uid + '.resource.GroupId'


      if !Boolean(currentSGId in originSGIdAry)
        originSGIdAry.push currentSGId

      MC.canvas_data.component[instanceUID].resource.SecurityGroups = originSGIdAry

      null

    getCheckBox : ( uid, checkbox ) ->

      resource = MC.canvas_data.component[ uid ].resource

      checkbox.ebsOptimized = "" + resource.EbsOptimized is 'true'
      checkbox.monitoring   = resource.InstanceMonitoring is 'enabled'

      watches = []
      asg = null
      monitorEnabled = true
      for id, comp of MC.canvas_data.component
        if comp.type is constant.AWS_RESOURCE_TYPE.AWS_CloudWatch_CloudWatch
          watches.push comp
        else if comp.type is constant.AWS_RESOURCE_TYPE.AWS_AutoScaling_Group
          if comp.resource.LaunchConfigurationName.indexOf( uid ) != -1
            asg = comp

      for watch in watches
        if watch.resource.MetricName.indexOf("StatusCheckFailed") != -1
          for d in watch.resource.Dimensions
            if d.value and d.value.indexOf( asg.uid ) != -1
              monitorEnabled = false
              break

          if not monitorEnabled
            break

      checkbox.monitorEnabled = monitorEnabled

      null

    getAmi : ( uid, data ) ->

      ami_id = MC.canvas_data.component[ uid ].resource.ImageId
      ami    = MC.data.dict_ami[ami_id]

      data.instance_ami = {
        name : ami.name
        icon : "#{ami.osType}.#{ami.architecture}.#{ami.rootDeviceType}.png"
      }
      null

    getKeyPair : ( uid, data )->

      keypair_id = MC.extractID MC.canvas_data.component[ uid ].resource.KeyName
      data.keypair = MC.aws.kp.getList( keypair_id )

      null

    addKP : ( kp_name ) ->

      result = MC.aws.kp.add kp_name

      if not result
        return result

      uid = @get 'uid'
      MC.canvas_data.component[ uid ].resource.KeyName = "@#{result}.resource.KeyName"
      true

    deleteKP : ( key_name ) ->

      MC.aws.kp.del key_name

      # Update data of this model
      for kp, idx in @attributes.keypair
        if kp.name is key_name
          @attributes.keypair.splice idx, 1
          break

      null

    setKP : ( key_name ) ->

      uid = this.get 'uid'
      MC.canvas_data.component[ uid ].resource.KeyName = "@#{MC.canvas_property.kp_list[key_name]}.resource.KeyName"

      null

    getInstanceType : ( uid, data ) ->

      ami_info = MC.canvas_data.layout.component.node[ uid ]

      current_instance_type = MC.canvas_data.component[ uid ].resource.InstanceType

      view_instance_type = _.map this._getInstanceType( ami_info ), ( value )->

        main     : constant.INSTANCE_TYPE[value][0]
        ecu      : constant.INSTANCE_TYPE[value][1]
        core     : constant.INSTANCE_TYPE[value][2]
        mem      : constant.INSTANCE_TYPE[value][3]
        name     : value
        selected : current_instance_type is value

      data.instance_type = view_instance_type
      data.can_set_ebs   = EbsMap.hasOwnProperty current_instance_type
      null

    _getInstanceType : ( ami ) ->
      instance_type = MC.data.instance_type[MC.canvas_data.region]
      if ami.virtualizationType == 'hvm'
        instance_type = instance_type.windows
      else
        instance_type = instance_type.linux
      if ami.rootDeviceType == 'ebs'
        instance_type = instance_type.ebs
      else
        instance_type = instance_type['instance store']
      if ami.architecture == 'x86_64'
        instance_type = instance_type["64"]
      else
        instance_type = instance_type["32"]
      instance_type = instance_type[ami.virtualizationType]

      instance_type

    getSGList : () ->

      uid = this.get 'uid'
      sgAry = MC.canvas_data.component[uid].resource.SecurityGroups

      sgUIDAry = []
      _.each sgAry, (value) ->
        sgUID = value.slice(1).split('.')[0]
        sgUIDAry.push sgUID
        null

      return sgUIDAry

    setIPList : (inputIPAry) ->

      # find eni0
      eniUID = ''
      currentInstanceUID = this.get 'uid'
      currentInstanceUIDRef = '@' + currentInstanceUID + '.resource.InstanceId'
      allComp = MC.canvas_data.component
      _.each allComp, (compObj) ->
        if compObj.type is constant.AWS_RESOURCE_TYPE.AWS_VPC_NetworkInterface
          instanceUIDRef = compObj.resource.Attachment.InstanceId
          deviceIndex = compObj.resource.Attachment.DeviceIndex
          if (currentInstanceUIDRef is instanceUIDRef) and (deviceIndex is '0')
            eniUID = compObj.uid
        null

      if eniUID
        realIPAry = MC.aws.eni.generateIPList eniUID, inputIPAry
        MC.aws.eni.saveIPList eniUID, realIPAry

    getAppLaunch : ( uid ) ->

      component = MC.canvas_data.component[uid]
      lc_data   = MC.data.resource_list[MC.canvas_data.region][ component.resource.LaunchConfigurationARN ]

      this.set 'name', component.name
      this.set 'lc',   lc_data
      this.set 'uid',  uid

  }

  new LaunchConfigModel()
