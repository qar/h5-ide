#############################
#  View(UI logic) for design/property/cgw
#############################

define [ '../base/view', 'text!./template/stack.html' ], ( PropertyView, template ) ->

  template = Handlebars.compile template

  StaticSubView = PropertyView.extend {
    events :
      "click #changeAmi"         : "showChangeAmiPanel"
      "click #confirmChangeAmi"  : "changeAmi"
      "click #cancelChangeAmi"   : "hideChangeAmiPanel"
      "drop  #changeAmiDropZone" : "onDropAmi"

    render : () ->
        @$el.html template @model.attributes
        @model.attributes.name

    showChangeAmiPanel : ()->
      $("#changeAmiPanel").show().siblings(".property-ami-info").hide()
      $("#changeAmiDropZone").children().hide().filter("p").show()
      $("#confirmChangeAmiWrap").hide()
      null

    hideChangeAmiPanel : ()->
      $("#changeAmiPanel").hide().siblings(".property-ami-info").show()
      null

    onDropAmi : ( event, amiId )->
      $("#changeAmiPanel").data("amiId", amiId)
      $("#confirmChangeAmiWrap").show()

      canChangeAmi = @model.canChangeAmi( amiId )
      if canChangeAmi is true
        $("#changeAmiWarning").hide()
        $("#confirmChangeAmi").show()
      else
        $("#changeAmiWarning").html(canChangeAmi).show()
        $("#confirmChangeAmi").hide()

      $("#changeAmiDropZone").children().show().filter("p").hide()
      $("#changeAmiDropZone").find("img").attr("src", "assets/images/ide/ami/" + @model.getAmiPngName( amiId ) + ".png")
      null

    changeAmi : ()->
      @model.changeAmi( $("#changeAmiPanel").data("amiId") )
      @render()
      @setTitle @model.get("name")
      null
  }

  new StaticSubView()
