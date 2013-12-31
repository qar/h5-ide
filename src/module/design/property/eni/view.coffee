#############################
#  View(UI logic) for design/property/eni
#############################

define [ '../base/view',
         'text!./template/stack.html',
         'text!./template/eni_list.html',
         'i18n!nls/lang.js'
], ( PropertyView, template, list_template, lang ) ->

    template = Handlebars.compile template
    list_template = Handlebars.compile list_template

    ENIView = PropertyView.extend {

        events   :
            "change #property-eni-desc"             : "setEniDesc"
            "change #property-eni-source-check"     : "setEniSourceDestCheck"

            'click .toggle-eip'                     : 'setEip'
            'click #property-eni-ip-add'            : "addIp"
            'click #property-eni-list .icon-remove' : "removeIp"
            'blur .input-ip'                        : 'syncIPList'

        render     : () ->
            @$el.html( template( @model.attributes ) )

            @refreshIPList()

            $("#prop-appedit-eni-list").html list_template @model.attributes

            @model.attributes.name

        setEniDesc : ( event ) ->
            @model.setEniDesc event.target.value
            null

        setEniSourceDestCheck : ( event ) ->
            @model.setSourceDestCheck event.target.checked
            null

        addIp : () ->
            if $("#property-eni-ip-add").hasClass("disabled")
                return

            @model.addIp()
            @refreshIPList()
            null

        setEip : ( event ) ->
            $target = $(event.currentTarget)
            index   = $target.closest("li").index()
            attach  = not $target.hasClass("associated")

            if attach
                tooltip = lang.ide.PROP_INSTANCE_IP_MSG_4
            else
                tooltip = lang.ide.PROP_INSTANCE_IP_MSG_3
            $target.toggleClass("associated", attach).data("tooltip", tooltip)

            @model.attachEip index, attach
            null

        removeIp : (event) ->

            $li = $(event.currentTarget).closest("li")
            index = $li.index()
            $li.remove()

            @model.removeIp( index )
            @updateIPAddBtnState( true )
            null


        syncIPList : (event) ->

            ipItems = $('#property-eni-list .input-ip-item')
            $target = $( event.currentTarget )

            if not $target.parsley 'validate'
                return

            ip = $target.siblings( ".input-ip-prefix" ).text() + $target.val()
            autoAssign = ip is "x" or ip is "x.x"

            @model.setIp $target.index(), ip, autoAssign
            null

        refreshIPList : ( event ) ->
            $( '#property-eni-list' ).html( MC.template.propertyIpList( @model.attributes.ips ) )
            @updateIPAddBtnState()

            @validateIPList()
            null

        validateIPList : () ->

            that = this
            valid = ( val ) ->
                validDOM         = $(this)
                inputValue       = validDOM.val()
                inputValuePrefix = validDOM.siblings(".input-ip-prefix").text()
                currentInputIP   = inputValuePrefix + inputValue
                prefixAry        = inputValuePrefix.split('.')

                ###### validation format
                ipIPFormatCorrect = false
                # for 10.0.0.
                if prefixAry.length is 4
                    if inputValue is 'x'
                        ipIPFormatCorrect = true
                    else if MC.validate 'ipaddress', (inputValuePrefix + inputValue)
                        ipIPFormatCorrect = true
                # for 10.0.
                else
                    if inputValue is 'x.x'
                        ipIPFormatCorrect = true
                    else if MC.validate 'ipaddress', (inputValuePrefix + inputValue)
                        ipIPFormatCorrect = true

                if !ipIPFormatCorrect
                    return 'Invalid IP address'
                else
                    result = that.model.isValidIp( currentInputIP )
                    if result isnt true
                        return result

            for el in $("#property-eni-list").children().find("input")
                $(el).parsley "custom", { validator : valid, thisArg : el }
            null


        updateIPAddBtnState : ( enabled ) ->
            if enabled is undefined
                enabled = @model.canAddIP()

            if enabled is true
                tooltip = "Add IP Address"
            else
                if _.isString enabled
                    tooltip = enabled
                else
                    tooltip = "Cannot add IP address"
                enabled = false

            $("#property-eni-ip-add").toggleClass("disabled", !enabled).data("tooltip", tooltip)
            null

    }

    new ENIView()
