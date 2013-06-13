#*************************************************************************************
#* Filename     : public_service.coffee
#* Creator      : gen_service.sh
#* Create date  : 2013-06-04 15:13:07
#* Description  : service know back-end api
#* Action       : 1.invoke MC.api (send url, method, data)
#*                2.invoke parser
#*                3.invoke callback
# ************************************************************************************
# (c)Copyright 2012 Madeiracloud  All Rights Reserved
# ************************************************************************************

define [ 'MC', 'public_parser', 'result_vo' ], ( MC, public_parser, result_vo ) ->

    URL = '/public/'

    #private
    send_request =  ( api_name, src, param_ary, parser, callback ) ->

        #check callback
        if callback is null
            console.log "public." + api_name + " callback is null"
            return false

        try

            MC.api {
                url     : URL
                method  : api_name
                data    : param_ary
                success : ( result, return_code ) ->

                    #resolve result
                    param_ary.splice 0, 0, { url:URL, method:api_name, src:src }
                    forge_result = {}
                    forge_result = parser result, return_code, param_ary

                    callback forge_result

                error : ( result, return_code ) ->

                    forge_result = {}
                    forge_result.return_code      = return_code
                    forge_result.is_error         = true
                    forge_result.error_message    = result.toString()

                    callback forge_result
            }

        catch error
            console.log "public." + api_name + " error:" + error.toString()


        true
    # end of send_request

    #def get_hostname(self, region_name, instance_id):
    get_hostname = ( src, region_name, instance_id, callback ) ->
        send_request "get_hostname", src, [ region_name, instance_id ], public_parser.parserGetHostnameReturn, callback
        true

    #def get_dns_ip(self, region_name):
    get_dns_ip = ( src, region_name, callback ) ->
        send_request "get_dns_ip", src, [ region_name ], public_parser.parserGetDnsIpReturn, callback
        true


    #############################################################
    #public
    get_hostname                 : get_hostname
    get_dns_ip                   : get_dns_ip

