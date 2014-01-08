#############################
#  View Mode for design/property/stack
#############################

define ['../base/model', 'constant', "Design" ], ( PropertyModel, constant, Design ) ->

  typeMap =
    'ec2-classic' : 'EC2 Classic'
    'ec2-vpc'     : 'EC2 VPC'
    'default-vpc' : 'Default VPC'
    'custom-vpc'  : 'Custom VPC'

  StackModel = PropertyModel.extend {

    init : () ->

      design = Design.instance()

      @set {
        name   : design.get("name").replace(/\s+/g, '')
        id     : design.get("id")
        type   : typeMap[ design.type() ]
        region : constant.REGION_SHORT_LABEL[ design.region() ]
        isApp  : @isApp
      }

      @getNetworkACL()

      if @isApp
        @getAppSubscription()
      else
        @getSubscription()


      @set Design.instance().getCost()
      null

    addSubscription : ( data ) ->

      TopicModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_SNS_Topic )

      if TopicModel.allObjects().length == 0
        new TopicModel()

      SubscriptionModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_SNS_Subscription )

      subs = @get("subscription")

      if not data.uid
        sub_comp = new SubscriptionModel( data )
        subs.push sub_comp.toJSON()
      else
        sub_comp = Design.instance().component( data.uid )
        sub_comp.set("protocol", data.protocol)
        sub_comp.set("endpoint", data.endpoint)
        for sub, idx in subs
          if sub.id is data.uid
            sub.protocol = data.protocol
            sub.endpoint = data.endpoint
            break
      null

    deleteSNS : ( uid ) ->

      sub_list = @get 'subscription'
      for sub, idx in sub_list
        if sub.id is uid
          sub_list.splice idx, 1
          break

      Design.instance.component(uid).remove()
      null

    getSubscription : () ->

      SubscriptionModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_SNS_Subscription )
      AsgNotifyModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_AutoScaling_NotificationConfiguration )

      subs = _.map SubscriptionModel.allObjects(), ( sub )-> sub.toJSON()
      @set "subscription", subs
      @set "has_asg", AsgNotifyModel.allObjects().length > 0

    getAppSubscription : () ->

      for comp_uid, comp of MC.canvas_data.component

        if comp.type is constant.AWS_RESOURCE_TYPE.AWS_SNS_Topic

          topic_arn = comp.resource.TopicArn

          @set 'snstopic', {
            name : comp.resource.DisplayName
            arn  : topic_arn
          }
          break

      subs = MC.data.resource_list[MC.canvas_data.region].Subscriptions
      subscription = []

      if topic_arn and subs
        for sub in subs
          # Ignore Subscription that has `topic` attribute
          if sub.TopicArn is topic_arn
            subscription.push {
              protocol : sub.Protocol
              endpoint : sub.Endpoint
              arn      : sub.SubscriptionArn
            }

      @set 'subscription', subscription

    createAcl : ()->
      ACLModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_VPC_NetworkAcl )
      (new ACLModel()).id

    getNetworkACL : ()->

      if not Design.instance().typeIsVpc()
        return

      ACLModel = Design.modelClassForType( constant.AWS_RESOURCE_TYPE.AWS_VPC_NetworkAcl )

      networkAcls = []
      defaultACL  = null
      _.each ACLModel.allObjects(), ( acl )->
        aclObj = {
          uid         : acl.id
          name        : acl.get("name")
          rule        : acl.getRuleCount()
          association : acl.getAssoCount()
        }

        if acl.isDefault()
          defaultACL = aclObj
        else
          networkAcls.splice( _.sortedIndex( networkAcls, aclObj, "name" ), 0, aclObj )

        null

      if defaultACL
        networkAcls.splice( 0, 0, defaultACL )

      @set "networkAcls", networkAcls
      null
  }

  new StackModel()
