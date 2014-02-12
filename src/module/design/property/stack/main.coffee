####################################
#  Controller for design/property/stack module
####################################

define [ '../base/main',
         './model',
         './view',
         './app_view',
         '../sglist/main',
         'event',
         "Design"
], ( PropertyModule, model, view, app_view, sglist_main, ide_event, Design ) ->

    # Listen shared view events here
    app_view.on 'OPEN_ACL', ( uid ) ->
        PropertyModule.loadSubPanel( "ACL", uid )
        null


    # ide_events handlers are called with the scope ( this ) of current property.
    ideEvents = {}

    ideEvents[ ide_event.RESOURCE_QUICKSTART_READY ] = ()->
        ide_event.trigger ide_event.OPEN_PROPERTY
        null

    StackModule = PropertyModule.extend {

        ideEvents : ideEvents

        handleTypes : [ "Stack", "default" ]

        onUnloadSubPanel : ( id )->

            sglist_main.onUnloadSubPanel id

            if id is "ACL"
                @model.getNetworkACL()
                @view.refreshACLList()

        ### # # # # # # # # # # # #
        # For stack mode
        ###

        # After initStack is called, this method will be called to setup connection between
        # model / view. It is called only once.
        setupStack : () ->
            me = @

            @view.on 'STACK_NAME_CHANGED', ( name ) ->
                design = Design.instance()
                design.set("name", name)
                ide_event.trigger ide_event.UPDATE_DESIGN_TAB, design.get("id"), name + ' - stack'
                null

            @view.on 'OPEN_ACL', ( uid ) ->
                PropertyModule.loadSubPanel( "ACL", uid )
                null
            null

        # In initStack, all we have to do is to assign this.model / this.view
        initStack : ( uid ) ->
            @model = model
            @model.isApp = false
            @model.isAppEdit = false
            @view  = view
            null

        # This method will be called after this property has rendered
        afterLoadStack : () ->
            sglist_main.loadModule @model
            null

        ### # # # # # # # # # # # #
        # For app mode
        ###

        initApp : ( uid ) ->
            @model = model
            @model.isApp = true
            @model.isAppEdit = false
            @view  = view
            null

        afterLoadApp : () ->
            sglist_main.loadModule @model
            null

        ### # # # # # # # # # #
        ###

        initAppEdit : ()->
            @model = model
            @model.isApp = false
            @model.isAppEdit = true
            @view  = view
            null

        afterLoadAppEdit : () ->
            sglist_main.loadModule @model
            null
    }

    null
