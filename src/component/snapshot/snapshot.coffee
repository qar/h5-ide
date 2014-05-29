define ['CloudResources', 'constant', 'combo_dropdown', "UI.modalplus", 'toolbar_modal', "i18n!nls/lang.js", './snapshot_template.js'],
    (CloudResources, constant, combo_dropdown, modalPlus, toolbar_modal, lang, template)->
    fetched = false
    snapshotRes = Backbone.view.extend
        constructor: (options)->
            @collection = CloudResources constant.RESTYPE.DHCP, Design.instance().region()
            @listenTo @collection, 'change', @render
            @listenTo @collection, 'update', @render
        remove: ()->
            @.isRemoved = ture
            Backbone.View::remove.call @

        render: ()->
            if App.user.hasCredential()
                if not fetched
                    @collection.fetch().then =>
                        @render()
                    fetched = true
                    return false
                @renderManager()
            else
                @renderNoCredential()

        renderDropdown: ()->
            option =
                manageBtnValue: lang.ide.PROP_VPC_MANAGE_SNAPSHOT
                filterPlaceHolder: lang.ide.PROP_VPC_FILTER_SNAPSHOT
            @dropdown = new combo_dropdown(option)

            selection = lang.ide.PROP_VOLUME_SNAPSHOT_SELECT
            @dropdown.setSelection selection

            @dropdown.on 'open', @openDropdown, @
            @dropdown.on 'filter', @filterDropdown, @
            @dropdown.on 'change', @selectSnapshot, @
            @dropdown

        openDropdown: ->
            if App.user.hasCredential()

            else
                @renderNoCredential()

        renderNoCredential: ->
            new modalPlus(
                title: lang.ide.SETTINGS_CRED_DEMO_SETUP
                template: lang.ide.SETTINGS_CRED_DEMO_TIT
            )
        renderManager: ()->
            @manager = new toolbar_modal @getModalOptions()
            @manager.on 'refresh', @refreshManager, @
            @manager.on "slidedown", @renderSlides, @
            @manager.on 'action', @doAction, @
            @manager.on 'close', =>
                @manager.remove()
            @manager.render()

        initManager: ()->
            if not fetched
                fetched = true
                @collection.fetchForce().then @renderManager, @renderManager
                return false
            content = template.content items:@collection.toJSON()
            @manager?.setContent content

        renderSlides: (which, checked)->
            tpl = template['slide_'+ which]
            slides = @getSlides()
            slides[which]?.call @, tpl, checked

        getSlides: ->
            'delete': (tpl, checked)->
                checkedAmount = checked.length
                if not checkedAmount
                    return
                data = {}
                if checkedAmount is 1
                    data.selectedName = checked[0].data.name
                else
                    data.selectedCount = checkedAmount
                @manager.setSlide tpl data
            'create':(tpl)->
                data =
                    snapshot : {}
                @dropdown = @dropdown or @renderDropdown()
                @manager.$el.find('#select_vol').html(@dropdown.$el)


        getModalOptions: ->
            that = @
            region = Design.instance().get('region')
            regionName = constant.REGION_SHORT_LABEL[ region ]

            title: "Manage DHCP Options in #{regionName}"
            slideable: true
            context: that
            buttons: [
                {
                    icon: 'new-stack'
                    type: 'create'
                    name: 'Create Snapshot'
                }
                {
                    icon: 'duplicate'
                    type: 'duplicate'
                    disabled: true
                    name: 'Duplicate'
                }
                {
                    icon: 'del'
                    type: 'delete'
                    disabled: true
                    name: 'Delete'
                }
                {
                    icon: 'refresh'
                    type: 'refresh'
                    name: ''
                }
            ]
            columns: [
                {
                    sortable: true
                    width: "20%" # or 40%
                    name: 'Name'
                }
                {
                    sortable: true
                    width: "20%" # or 40%
                    name: 'Capicity'
                }
                {
                    sortable: true
                    width: "30%" # or 40%
                    name: 'status'
                }
                {
                    sortable: false
                    width: "30%" # or 40%
                    name: 'Description'
                }
            ]