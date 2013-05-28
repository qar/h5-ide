#*************************************************************************************
#* Filename     : eni_parser.coffee
#* Creator      : gen_service.sh
#* Create date  : 2013-05-25 14:06:22
#* Description  : parser return data of eni
# ************************************************************************************
# (c)Copyright 2012 Madeiracloud  All Rights Reserved
# ************************************************************************************

define [ 'eni_vo', 'result_vo', 'constant' ], ( eni_vo, result_vo, constant ) ->


    #///////////////// Parser for DescribeNetworkInterfaces return (need resolve) /////////////////
    #private (resolve result to vo )
    resolveDescribeNetworkInterfacesResult = ( result ) ->
        #return
        ($.xml2json ($.parseXML result[1])).DescribeNetworkInterfacesResponse.networkInterfaceSet

    #private (parser DescribeNetworkInterfaces return)
    parserDescribeNetworkInterfacesReturn = ( result, return_code, param ) ->

        #1.resolve return_code
        result_vo.aws_result = result_vo.processAWSReturnHandler result, return_code, param

        #2.resolve return_data when return_code is E_OK
        if return_code == constant.RETURN_CODE.E_OK && !result_vo.aws_result.is_error

            resolved_data = resolveDescribeNetworkInterfacesResult result

            result_vo.aws_result.resolved_data = resolved_data


        #3.return vo
        result_vo.aws_result

    # end of parserDescribeNetworkInterfacesReturn


    #///////////////// Parser for DescribeNetworkInterfaceAttribute return (need resolve) /////////////////
    #private (resolve result to vo )
    resolveDescribeNetworkInterfaceAttributeResult = ( result ) ->
        #return
        ($.xml2json ($.parseXML result[1])).DescribeNetworkInterfaceAttributeResponse

    #private (parser DescribeNetworkInterfaceAttribute return)
    parserDescribeNetworkInterfaceAttributeReturn = ( result, return_code, param ) ->

        #1.resolve return_code
        result_vo.aws_result = result_vo.processAWSReturnHandler result, return_code, param

        #2.resolve return_data when return_code is E_OK
        if return_code == constant.RETURN_CODE.E_OK && !result_vo.aws_result.is_error

            resolved_data = resolveDescribeNetworkInterfaceAttributeResult result

            result_vo.aws_result.resolved_data = resolved_data


        #3.return vo
        result_vo.aws_result

    # end of parserDescribeNetworkInterfaceAttributeReturn


    #############################################################
    #public
    parserDescribeNetworkInterfacesReturn    : parserDescribeNetworkInterfacesReturn
    parserDescribeNetworkInterfaceAttributeReturn : parserDescribeNetworkInterfaceAttributeReturn

