####################################
#  Controller for design module
####################################

define [ 'i18n!nls/lang.js', 'jquery', 'MC.canvas.constant' ], (lang) ->

    #private
    loadModule = () ->

        #load remote design.js
        require [ 'design_view', 'design_model', 'property', 'event' ], ( View, model, property_main, ide_event ) ->

            #
            design_view_init       = null
            MC.data.design_submodule_count = 0

            #view
            view       = new View()
            view.listen model

            #listen event
            view.once 'DESIGN_COMPLETE', () ->
                console.log 'view:DESIGN_COMPLETE'
                #wrap 'resource', 'property', 'toolbar', 'canvas'
                wrap()

            #render
            view.render()

            #listen DESIGN_SUB_COMPLETE
            ide_event.onLongListen ide_event.DESIGN_SUB_COMPLETE, () ->
                console.log 'design:DESIGN_SUB_COMPLETE = ' + MC.data.design_submodule_count
                if MC.data.design_submodule_count is 3
                    design_view_init = view.$el.html()
                    MC.data.design_submodule_count = -1
                    #push event
                    ide_event.trigger ide_event.DESIGN_COMPLETE
                    ide_event.trigger ide_event.IDE_AVAILABLE
                    #off DESIGN_SUB_COMPLETE
                    ide_event.offListen ide_event.DESIGN_SUB_COMPLETE
                else
                    MC.data.design_submodule_count = MC.data.design_submodule_count + 1
                null

            #listen SAVE_DESIGN_MODULE
            ide_event.onLongListen ide_event.SAVE_DESIGN_MODULE, ( tab_id ) ->
                console.log 'design:SAVE_DESIGN_MODULE = ' + tab_id
                #save tab
                if tab_id.split( '-' )[0] is 'process'
                    model.saveProcessTab tab_id
                else
                    model.saveTab tab_id, view.html(), model.getCanvasData(), model.getCanvasProperty(), property_main.snapshot(), model.getOriginData()
                null

            #listen SWITCH_TAB
            ide_event.onLongListen ide_event.SWITCH_TAB, ( type, tab_id, region_name, result, current_platform ) ->

                console.log 'design:SWITCH_TAB, type = ' + type + ', tab_id = ' + tab_id + ', region_name = ' + region_name + ', current_platform = ' + current_platform
                #
                if type is 'OLD_STACK' or type is 'OLD_APP' then model.readTab type, tab_id else view.$el.html design_view_init
                #
                if type is 'NEW_STACK' or type is 'OPEN_STACK' or type is 'OPEN_APP'

                    #
                    #ide_event.trigger ide_event.SWITCH_LOADING_BAR, if type is 'NEW_STACK' then result else tab_id
                    #
                    if type is 'OPEN_STACK' or type is 'OPEN_APP'

                        #when OPEN_STACK or OPEN_APP result is resolved_data
                        model.setCanvasData result.resolved_data[0]

                    if type is 'OPEN_APP'
                        #get all resource data for app
                        model.getAppResourcesService region_name, tab_id

                    if type is 'OPEN_STACK'
                        #get all not exist ami data for stack
                        model.getAllNotExistAmiInStack region_name, tab_id

                    #temp
                    #when NEW_STACK result is tab_id
                    ide_event.trigger ide_event.OPEN_DESIGN, region_name, type, current_platform, tab_id, result

                    # Instead of posting a ide_event.OPEN_DESIGN to let property panel to figure it out what to do, here directly tells it to open a stack property.
                    ide_event.trigger ide_event.OPEN_PROPERTY, "component", ""
                null

            #listen
            ide_event.onLongListen ide_event.DELETE_TAB_DATA, ( tab_id ) ->
                console.log 'DELETE_TAB_DATA, tab_id = ' + tab_id
                model.deleteTab tab_id
                null

            #listen
            ide_event.onLongListen ide_event.UPDATE_TAB_DATA, ( original_tab_id, tab_id ) ->
                console.log 'UPDATE_TAB_DATA, original_tab_id = ' + original_tab_id + ', tab_id = ' + tab_id
                model.updateTab original_tab_id, tab_id
                null

            #listen
            ide_event.onLongListen ide_event.UPDATE_APP_RESOURCE, ( region_name, app_id, is_manual ) ->
                console.log 'UPDATE_APP_RESOURCE, is_manual = ' + is_manual
                if not app_id
                    return

                console.log 'UPDATE_APP_RESOURCE:' + region_name + ',' + app_id
                #is_manual = true
                model.getAppResourcesService region_name, app_id, is_manual

                # update app data from mongo
                model.updateAppTab region_name, app_id

                null

            #listen
            ide_event.onLongListen ide_event.UPDATE_STATUS_BAR, ( level ) ->
                console.log 'UPDATE_STATUS_BAR, level = ' + level
                view.updateStatusbar level

            model.on "SET_PROPERTY_PANEL", ( property_panel ) ->
                property_main.restore property_panel
                null


    #private
    unLoadModule = () ->
        #view.remove()

    #private
    wrap = () ->

        require [ 'resource', 'property', 'toolbar', 'canvas' ], ( resource, property, toolbar, canvas ) ->

            #load remote design/canvas
            canvas.loadModule()

            #load remote design/toolbar
            toolbar.loadModule()

            #load remote design/resource
            resource.loadModule()

            #load remote design/property
            property.loadModule()

    #public
    loadModule   : loadModule
    unLoadModule : unLoadModule
