define ['../base/view'
        './container'
        './template/app'
        'i18n!/nls/lang.js'
        'constant'
        'UI.modalplus'
], (PropertyView, Container, Tpl, lang, constant) ->
  view = PropertyView.extend

    events:
      'click .open-container'                    : 'openContainer'
      "OPTION_CHANGE .mesos-switch-versions"     : "switchVersion"

    initialize   : (options) ->

    openContainer: ()->
      @container = new Container(model: @model, appData: @data).render()

    switchVersion: (evt)->
      version = $(evt.currentTarget).find(".selection").text()
      @_render version.toString()

    render: ()->
      @_render()

    _render: (version)->
      @appData = _.map @appData, (model)->
        model.toJSON()
      if version
        data =  _.findWhere @appData, {version: version}
      else
        data = _.sortBy(@appData, "version")[0]

      data.versions = _.pluck @appData, 'version'

      data.host = Design.instance().serialize().host

      @data = data

      #Switch Command/Arguments
      data.isCommand = data.cmd and not data.args?.length || true

      @$el.html Tpl data
      @model.get 'name'



  new view()