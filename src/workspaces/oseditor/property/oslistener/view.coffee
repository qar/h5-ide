define [
    'constant'
    '../OsPropertyView'
    '../osport/view'
    './template/stack'


], ( constant, OsPropertyView, portView, template ) ->

    OsPropertyView.extend {

        events:
            'change [data-target]': 'updateAttribute'

        render: ->
            @$el.html template @getRenderData()
            @$el.append @reg( new portView model: @model ).render().el
            @

        getModelForUpdateAttr: ( e ) ->
            $target = $ e.currentTarget
            dataModel = $target.closest( '[data-model]' ).data 'model'
            if dataModel is 'listener' then @model else null

    }, {
        handleTypes: [ constant.RESTYPE.OSLISTENER ]
        handleModes: [ 'stack', 'appedit' ]
    }
