
define [], () ->

	#static
	STATIC = {
		E_OK : 0
	}

	#user vo
	user_vo = {
		userid      : null
		usercode    : null
		session_id  : null
		region_name : null
		email       : null
		has_cred    : null
	}

	#public
	STATIC  : STATIC
	user_vo : user_vo