define ["CloudResources", 'constant','combo_dropdown', 'UI.modalplus', 'toolbar_modal', 'i18n!nls/lang.js', './dhcp_template.js'], ( CloudResources, constant, comboDropdown, modalPlus, toolbarModal, lang, template )->
    dhcpView = Backbone.View.extend
        constructor:->
            @collection = CloudResources constant.RESTYPE.DHCP, Design.instance().region()
            @listenTo @collection, 'change', @render
            @listenTo @collection, 'update', @render
            option =
                manageBtnValue: lang.ide.PROP_VPC_MANAGE_DHCP
                filterPlaceHolder: lang.ide.PROP_VPC_FILTER_DHCP
            @dropdown = new comboDropdown option
            @dropdown.on 'open', @show , @
            @dropdown.on 'manage', @manageDHCP, @
            @dropdown.on 'change', @setDHCP, @
            @dropdown.on 'filter', @filter, @
            @
        remove: ()->
            @.isRemoved = true
            Backbone.View::remove.call @
        render: ->
            console.log @collection.toJSON()
            @renderDropdown()
        show: ->
            if App.user.hasCredential()
                if not @fetched
                    @collection.fetch()
                    @fetched = true
                    null
            else
                @renderNoCredential()
        renderNoCredential: ->
            @dropdown.render('nocredential').toggleControls false
        renderLoading: ->
            @dropdown.render('loading').toggleControls false
        renderDropdown: ->
            data = @collection.toJSON()
            selection = template.selection data
            @dropdown.setSelection "Auto-assigned Set"
    dhcpView