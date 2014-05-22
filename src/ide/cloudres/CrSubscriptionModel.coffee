
define [ "./CrModel", "ApiRequest" ], ( CrModel, ApiRequest )->

  CrSubscriptionModel = CrModel.extend {

    ### env:dev ###
    ClassName : "CrSubscriptionModel"
    ### env:dev:end ###

    taggable : false

    defaults :
      Endpoint        : ""
      Protocol        : ""
      TopicName       : ""
      TopicArn        : ""
      SubscriptionArn : ""

    isRemovable : ()->
      @attributes.SubscriptionArn isnt "PendingConfirmation" and @attributes.SubscriptionArn isnt "Deleted"

    set : ()->
      Backbone.Model.prototype.set.apply this, arguments
      @attributes.TopicName = @attributes.TopicArn.split(":").pop()
      return

    doCreate  : ()->
      ApiRequest("sns_Subscribe", {
        region_name : @getCollection().category
        topic_arn   : @get("TopicArn")
        protocol    : @get("Protocol")
        endpoint    : @get("Endpoint")
      }).then ( res )->
        try
          arn = res.SubscribeResponse.SubscribeResult.SubscriptionArn
        catch e
          throw McError( ApiRequest.Errors.InvalidAwsReturn, "Subscription created but aws returns invalid ata." )

        self.set {
          id : CrSubscriptionModel.uniqueId()
          SubscriptionArn : arn
        }
        console.info "Subscription Created", self

        self

    doDestroy : ()->
      if @isRemovable()
        return ApiRequest("sns_Unsubscribe", {
          region_name : @getCollection().category
          sub_arn     : @get("SubscriptionArn")
        })

      defer = Q.defer()
      defer.resolve McError( ApiRequest.Errors.InvalidMethodCall, "Cannot unsubscribe pending subscription.", self )
      return defer.promise

  }, {
    uniqueId : ()-> _.uniqueId("CrSnsSub_")
  }
