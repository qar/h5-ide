#############################
#  View Mode for design/property/vgw
#############################

define ->

    require [ "module/design/property/base/model", "Design", "constant" ], ( PropertyModel, Design, constant ) ->

      StaticModel = PropertyModel.extend {

        init : ( id ) ->

          component = Design.instance().component( id )

          isIGW = component.type is constant.AWS_RESOURCE_TYPE.AWS_VPC_InternetGateway

          @set "isIGW", isIGW
          @set "id", id

          if @isApp

            @set "readOnly", true

            appData = MC.data.resource_list[ MC.canvas_data.region ]
            appId   = component.get("appId")

            data    = appData[ appId ]

            if data
              if isIGW
                if data.attachmentSet and data.attachmentSet.item.length
                  item = data.attachmentSet.item[0]
              else if data.attachments and data.attachments.item.length
                item = data.attachments.item[0]

            if item
              @set "state", item.state
              vpcId = item.vpcId

            vpc = appData[ vpcId ]
            if vpc then vpcId += " (#{vpc.cidrBlock})"

            @set "id", gatewayId
            @set "vpc", vpcId

          null
      }

      new StaticModel()
