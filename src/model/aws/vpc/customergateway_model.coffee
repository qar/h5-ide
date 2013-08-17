#*************************************************************************************
#* Filename     : customergateway_model.coffee
#* Creator      : gen_model.sh
#* Create date  : 2013-06-05 10:35:17
#* Description  : model know service
#* Action       : 1.define vo
#*                2.invoke api by service
#*                3.dispatch event to controller
# ************************************************************************************
# (c)Copyright 2012 Madeiracloud  All Rights Reserved
# ************************************************************************************

define [ 'backbone', 'customergateway_service'], ( Backbone, customergateway_service) ->

    CustomerGatewayModel = Backbone.Model.extend {

        ###### vo (declare variable) ######
        defaults : {
            vo : {}
        }

        ###### api ######
        #DescribeCustomerGateways api (define function)
        DescribeCustomerGateways : ( src, username, session_id, region_name, gw_ids=null, filters=null ) ->

            me = this

            src.model = me

            customergateway_service.DescribeCustomerGateways src, username, session_id, region_name, gw_ids, filters, ( aws_result ) ->

                if !aws_result.is_error
                #DescribeCustomerGateways succeed

                    customergateway_info = aws_result.resolved_data

                    #set vo


                else
                #DescribeCustomerGateways failed

                    console.log 'customergateway.DescribeCustomerGateways failed, error is ' + aws_result.error_message

                #dispatch event (dispatch event whenever login succeed or failed)
                if src.sender and src.sender.trigger then src.sender.trigger 'VPC_CGW_DESC_CUST_GWS_RETURN', aws_result



    }

    #############################################################
    #private (instantiation)
    customergateway_model = new CustomerGatewayModel()

    #public (exposes methods)
    customergateway_model

