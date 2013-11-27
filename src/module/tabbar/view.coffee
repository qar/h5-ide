#############################
#  View(UI logic) for tabbar
#############################

define [ 'event',
         'text!./module/tabbar/template.html',
         'backbone', 'jquery', 'handlebars', 'UI.tabbar'
], ( ide_event, tmpl ) ->

    TabBarView = Backbone.View.extend {

        el       : $( '#tab-bar' )

        template : Handlebars.compile tmpl

        current_tab : null

        events   :
            'OPEN_TAB'              : 'openTabEvent'
            'CLOSE_TAB'             : 'closeTabEvent'
            'CLOSE_TAB_RESTRICTION' : 'closeTabRestriction'

        initialize : ->

            $( document.body ).on 'click', '.new-stack-dialog',          this, @openNewStackDialog
            $( document.body ).on 'click', '#reload-account-attributes', this, @reloadAccountAttributes
            $( document.body ).on 'click', '#close-tab-confirm',         this, @_closeTabConfirm

            @listenTo ide_event, 'UPDATE_DESIGN_TAB_ICON', @updateTabIcon

        render   : () ->
            console.log 'tabbar render'
            $( this.el ).html this.template()

        reloadAccountAttributes: () ->
             window.location.reload()

        openTabEvent  : ( event, original_tab_id, tab_id ) ->
            console.log 'openTabEvent'
            console.log 'original_tab_id = ' + original_tab_id + ', tab_id = ' + tab_id

            if original_tab_id is tab_id
                return

            # set current tab id
            MC.forge.other.setCurrentTabId tab_id

            # get tab_type
            tab_type = tab_id.split( '-' )[0]

            switch tab_type
                when 'dashboard'
                    this.trigger 'SWITCH_DASHBOARD',     original_tab_id, tab_id
                when 'new'
                    this.trigger 'SWITCH_NEW_STACK_TAB', original_tab_id, tab_id, $( '#tab-bar-' + tab_id ).find('a').attr('title')
                when 'stack'
                    this.trigger 'SWITCH_STACK_TAB',     original_tab_id, tab_id
                when 'app'
                    this.trigger 'SWITCH_APP_TAB',       original_tab_id, tab_id
                when 'process'
                    this.trigger 'SWTICH_PROCESS_TAB',   original_tab_id, tab_id
                else
                    console.log 'no find tab type'

            null

        closeTabEvent : ( event, tab_id ) ->
            console.log 'closeTabEvent'
            #push event
            this.trigger 'CLOSE_STACK_TAB',  tab_id
            null

        changeIcon : ( tab_id ) ->
            console.log 'changeIcon'
            console.log $( '#tab-bar-' + tab_id ).children().find( 'i' ).attr( 'class' )
            null

        updateTabCloseState : ( tab_id ) ->
            console.log 'updateTabCloseState, tab_id = ' + tab_id
            close_target = $( '#tab-bar-' + tab_id ).children( '.icon-close' )
            close_target.removeClass 'close-restriction'
            close_target.addClass    'close-tab'

        closeTab   : ( tab_id ) ->
            console.log 'closeTab'
            #$( '#tab-bar-' + tab_id ).children().last().trigger( 'mousedown' )
            target = $( '#tab-bar-' + tab_id ).find( '.close-tab' )
            return if $( '#tab-bar-' + tab_id ).length is 0
            if target.length > 0
                target.addClass 'auto-close'
                target.trigger 'click'
            else
                @trueCloseTab null, tab_id
            null

        changeDashboardTabname   : ( tab_name ) ->
            console.log 'changeDashboardTabname'
            $( '#tab-bar-dashboard' ).children().html '<i class="icon-dashboard icon-tabbar-label"></i>' + tab_name
            null

        openNewStackDialog : ( event ) ->
            console.log 'openNewStackDialog'
            console.log $( event.currentTarget ).attr 'data-supported-platform'
            event.data.trigger 'SELECE_PLATFORM', $( event.currentTarget ).attr 'data-supported-platform'
            null

        updateCurrentTab : ( tab_id, tab_name ) ->
            console.log 'updateCurrentTab', tab_id, tab_name
            original_tab_id = null
            _.each $( '.tabbar-group' ).children(), ( item ) ->
                if $( item ).attr( 'class' ) is 'active'
                    console.log $( item )

                    # update temp html tag property
                    $( item ).attr 'id', 'tab-bar-' + tab_id
                    temp = $( $( item ).find( 'a' )[0] )
                    temp.attr 'title',       tab_name
                    temp.attr 'data-tab-id', tab_id
                    temp.attr 'href',        '#tab-content-' + tab_id
                    temp.html temp.find( 'i' ).get( 0 ).outerHTML + tab_name

                    # set Tabbar.current
                    ide_event.trigger ide_event.UPDATE_DESIGN_TAB_TYPE, tab_id, tab_id.split( '-' )[0]

                    # get origin tab id
                    original_tab_id = temp.attr 'data-tab-id'

                    null
            return original_tab_id

        updateTabIcon : ( type, tab_id ) ->
            console.log 'updateTabIcon, type = ' + type + ', tab_id = ' + tab_id
            _.each $( '.tabbar-group' ).children(), ( item ) ->
                $item = $( item )
                if $item.attr( 'id' ) is 'tab-bar-' + tab_id
                    if type is 'stack' then classname = 'icon-stack-tabbar' else classname = 'icon-app-' + type.toLowerCase()
                    $item.find( 'i' ).removeClass()
                    $item.find( 'i' ).addClass 'icon-tabbar-label ' + classname

        #updateTabType : ( tab_id, tab_type ) ->
        #    console.log 'updateTabIcon, tab_id = ' + tab_id + ', tab_type = ' + tab_type
        #    _.each $( '.tabbar-group' ).children(), ( item ) ->
        #        $item = $( item )
        #        if $item.attr( 'id' ) is 'tab-bar-' + tab_id
        #            #$item.attr( 'data-tab-type', tab_type )
        #            $item.data( 'tab-type', tab_type )
        #            Tabbar.current = tab_type
        #            null

        closeTabRestriction : ( event, target, tab_name, tab_id ) ->
            console.log 'closeTabRestriction', target, tab_name, tab_id

            #if MC.canvas_property.original_json is JSON.stringify( MC.canvas_data )
            #    @trueCloseTab target, tab_id
            #else
            #    console.log 'eeeeeeeeeeeeeeeeeeeeeeee'

            @current_tab = target

            if MC.data.current_tab_id.split( '-' )[0] in [ 'process' ]
                @trueCloseTab @current_tab, tab_id
                return

            if MC.data.current_tab_id is tab_id
                data        = $.extend true, {}, MC.canvas_data
                origin_data = $.extend true, {}, MC.data.origin_canvas_data
            else
                data        = $.extend true, {}, MC.tab[ tab_id ].data
                origin_data = $.extend true, {}, MC.tab[ tab_id ].origin_data

            if _.isEqual( data, origin_data )
                @trueCloseTab @current_tab, tab_id
            else
                modal MC.template.closeTabRestriction { 'tab_name' : tab_name, 'tab_id' : tab_id }, true
            null

        _closeTabConfirm : ( event ) ->
            console.log 'closeTabConfirm, tab_id = ' + $( event.currentTarget ).attr 'data-tab-id'
            event.data.trueCloseTab event.data.current_tab, $( event.currentTarget ).attr 'data-tab-id'
            modal.close()

        trueCloseTab : ( target, tab_id ) ->
            console.log 'trueCloseTab'

            # update tab close state
            @updateTabCloseState tab_id

            # close design tab
            _.delay () ->
                ide_event.trigger ide_event.CLOSE_DESIGN_TAB, null, tab_id
            , 150

            null
    }

    return TabBarView
