#*************************************************************************************
#* Filename     : vpngateway_model.coffee
#* Creator      : gen_model.sh
#* Create date  : 2013-06-05 10:35:18
#* Description  : model know service
#* Action       : 1.define vo
#*                2.invoke api by service
#*                3.dispatch event to controller
# ************************************************************************************
# (c)Copyright 2012 Madeiracloud  All Rights Reserved
# ************************************************************************************

define [ 'backbone', 'vpngateway_service'], ( Backbone, vpngateway_service) ->

    VPNGatewayModel = Backbone.Model.extend {

        ###### vo (declare variable) ######
        defaults : {
            vo : {}
        }

        ###### api ######
        #DescribeVpnGateways api (define function)
        DescribeVpnGateways : ( src, username, session_id, region_name, gw_ids=null, filters=null ) ->

            me = this

            src.model = me

            vpngateway_service.DescribeVpnGateways src, username, session_id, region_name, gw_ids, filters, ( aws_result ) ->

                if !aws_result.is_error
                #DescribeVpnGateways succeed

                    vpngateway_info = aws_result.resolved_data

                    #set vo


                else
                #DescribeVpnGateways failed

                    console.log 'vpngateway.DescribeVpnGateways failed, error is ' + aws_result.error_message

                #dispatch event (dispatch event whenever login succeed or failed)
                if src.sender and src.sender.trigger then src.sender.trigger 'VPC_VGW_DESC_VPN_GWS_RETURN', aws_result



    }

    #############################################################
    #private (instantiation)
    vpngateway_model = new VPNGatewayModel()

    #public (exposes methods)
    vpngateway_model

