define [ 'constant', 'jquery', 'MC','i18n!nls/lang.js', 'customergateway_service' , '../result_vo' ], ( constant, $, MC, lang, cgwService ) ->

	isCGWHaveIPConflict = (callback) ->

		try
			if !callback
				callback = () ->

			# get current stack all cgw
			stackCGWIP = stackCGWName = stackCGWUID = null
			_.each MC.canvas_data.component, (compObj) ->
				if compObj.type is constant.AWS_RESOURCE_TYPE.AWS_VPC_CustomerGateway
					stackCGWIP = compObj.resource.IpAddress
					stackCGWName = compObj.name
					stackCGWUID = compObj.uid
				null

			# if have cgw in stack
			if stackCGWIP and stackCGWName and stackCGWUID

				currentRegion = MC.canvas_data.region
				cgwService.DescribeCustomerGateways {sender: this},
					$.cookie( 'usercode' ),
					$.cookie( 'session_id' ),
					currentRegion,  [], null, (result) ->

						checkResult = true
						conflictInfo = null

						if !result.is_error
							# get current aws all cgw
							cgwObjAry = result.resolved_data
							_.each cgwObjAry, (cgwObj) ->
								cgwId = cgwObj.customerGatewayId
								cgwIP = cgwObj.ipAddress
								cgwState = cgwObj.state
								if stackCGWIP isnt cgwIP and cgwState is 'available'
									conflictInfo = sprintf lang.ide.TA_MSG_ERROR_CGW_IP_CONFLICT, stackCGWName, stackCGWIP, cgwId, cgwIP
									checkResult = false
								null
						else
							callback(null)

						if checkResult
							callback(null)
						else
							validResultObj =
								level: constant.TA.ERROR
								info: conflictInfo

							callback(validResultObj)
							console.log(validResultObj)

						null

				# immediately return
				tipInfo = sprintf lang.ide.TA_MSG_ERROR_CGW_CHECKING_IP_CONFLICT
				return {
					level: constant.TA.ERROR,
					info: tipInfo
				}

			else
				callback(null)
		catch err
			callback(null)

	isCGWHaveIPConflict : isCGWHaveIPConflict
