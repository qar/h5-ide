#############################
#  validation
#############################

define [ 'event', 'component/trustedadvisor/validation/main',
         'jquery', 'underscore'
], ( ide_event, validation_main ) ->

    #privte
    validComp = ( type, obj ) ->

        try

            temp     = type.split '.'
            filename = temp[ 0 ]
            method   = temp[ 1 ]
            func     = validation_main[ filename ][ method ]

            if _.isFunction func

                result = func obj

                if !result
                    console.log 'validation success'
                    true
                else
                    console.log result
                    console.log 'validation failed'
                    #
                    ide_event.trigger ide_event.UPDATE_STATUS_BAR, result.level
                    #
                    false

            else
                console.log 'func not found'

        catch error
            console.log "validComp error #{ error }"

    validAll = ( obj ) ->
        #validComp 'instance.checkValue', uid
        #validComp 'instance.bbb', uid
        #validComp 'instance.ccc', uid

    #public
    validComp : validComp
    validAll  : validAll