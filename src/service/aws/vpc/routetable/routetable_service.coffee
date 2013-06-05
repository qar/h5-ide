#*************************************************************************************
#* Filename     : routetable_service.coffee
#* Creator      : gen_service.sh
#* Create date  : 2013-06-04 15:13:25
#* Description  : service know back-end api
#* Action       : 1.invoke MC.api (send url, method, data)
#*                2.invoke parser
#*                3.invoke callback
# ************************************************************************************
# (c)Copyright 2012 Madeiracloud  All Rights Reserved
# ************************************************************************************

define [ 'MC', 'routetable_parser', 'result_vo' ], ( MC, routetable_parser, result_vo ) ->

    URL = '/aws/vpc/routetable/'

    #private
    send_request =  ( api_name, src, param_ary, parser, callback ) ->

        #check callback
        if callback is null
            console.log "routetable." + api_name + " callback is null"
            return false

        try

            MC.api {
                url     : URL
                method  : api_name
                data    : param_ary
                success : ( result, return_code ) ->

                    #resolve result
                    param_ary.splice 0, 0, src
                    result_vo.aws_result = parser result, return_code, param_ary

                    callback result_vo.aws_result

                error : ( result, return_code ) ->

                    result_vo.aws_result.return_code      = return_code
                    result_vo.aws_result.is_error         = true
                    result_vo.aws_result.error_message    = result.toString()

                    callback result_vo.aws_result
            }

        catch error
            console.log "routetable." + api_name + " error:" + error.toString()


        true
    # end of send_request

    #def DescribeRouteTables(self, username, session_id, region_name, rt_ids=None, filters=None):
    DescribeRouteTables = ( src, username, session_id, region_name, rt_ids=null, filters=null, callback ) ->
        send_request "DescribeRouteTables", src, [ username, session_id, region_name, rt_ids, filters ], routetable_parser.parserDescribeRouteTablesReturn, callback
        true


    #############################################################
    #public
    DescribeRouteTables          : DescribeRouteTables

