#############################
#  View(UI logic) for component/statestatus
#############################

define [ 'event'
       , 'text!./template.html'
       , 'backbone'
       , 'jquery'
       , 'handlebars'

], ( ide_event, template ) ->

    StateStatusView = Backbone.View.extend

        el: '#status-bar-modal'

        template: {}

        events:
            'click .modal-close': 'closePopup'

        initialize: () ->

            @compileTpl()
            @registerHelper()

            parent = @
            @itemView = Backbone.View.extend
                tagName: 'li'
                className: 'state-status-item'
                template: parent.template.item
                render: () ->
                    @$el.html @template @model.toJSON()
                    @


        render: () ->

            @$statusModal = @$el

            @$el.html @template.modal {}
            @$( '.modal-state-statusbar' ).html @template.content {}

            @renderAllItem()

            @$el.show()

            @

        renderAllItem: () ->
            @model.get( 'items' ).each @renderItem, this


        renderItem: ( model, index ) ->
            if index is 0
                @$( '.scroll-content' ).html '<ul class="state-status-list"></ul>'

            view = new @itemView model: model
            @$( '.state-status-list' ).append view.render().el



        renderStateBar: ( option ) ->
            if _.isObject option
                $stateBar = $ 'statusbar-btn'
                if option.success
                    $stateBar
                        .find( '.state-success b' )
                        .val option.success

                if option.failed
                    $stateBar
                        .find( '.state-failed b' )
                        .val option.failed


        registerHelper: () ->
            Handlebars.registerHelper 'UTC', ( text ) ->
                new Handlebars.SafeString new Date( text ).toUTCString()

        compileTpl: () ->

            # generate template
            tplRegex = /(\<!-- (.*) --\>)(\n|\r|.)*?(?=\<!-- (.*) --\>)/ig
            tplHTMLAry = template.match tplRegex
            htmlMap = {}

            _.each tplHTMLAry, ( tplHTML ) ->
                commentHead = tplHTML.split( '\n' )[ 0 ]
                tplType = commentHead.replace( /(<!-- )|( -->)/g, '' )
                htmlMap[ tplType ] = tplHTML
                null

            stateStatusModalHTML = htmlMap[ 'statestatus-template-modal' ]
            stateStatusContentHTML = htmlMap[ 'statestatus-template-status-content' ]
            stateStatusItemHTML = htmlMap[ 'statestatus-template-status-item' ]

            #Handlebars.registerPartial 'statestatus-template-status-item', stateStatusItemHTML

            @template.modal     = Handlebars.compile stateStatusModalHTML
            @template.content   = Handlebars.compile stateStatusContentHTML
            @template.item      = Handlebars.compile stateStatusItemHTML

            @template




        refreshStateStatusList: () ->

            that = this
            stateStatusDataAry = that.model.get( 'stateStatusDataAry' )

            stateStatusViewAry = []
            _.each stateStatusDataAry, ( statusObj ) ->
                stateStatusViewAry.push( {
                    # state_id: "State #{logObj.state_id}",
                    # log_time: logObj.time,
                    # stdout: logObj.stdout,
                    # stderr: logObj.stderr
                } )
                null

            renderHTML = that.template.item( {
                state_statuses: stateStatusViewAry
            } )

            that.$stateStatusList.html renderHTML

        closePopup : ->
            if @$statusModal.html()
                @$statusModal.empty()
                @trigger 'CLOSE_POPUP'
                @$statusModal.hide()


    StateStatusView