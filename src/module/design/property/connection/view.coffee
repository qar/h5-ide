#############################
#  View(UI logic) for design/property/cgw
#############################

define [ '../base/view', 'text!./template/stack.html' ], ( PropertyView, template ) ->

    template = Handlebars.compile template

    ConnectionView = PropertyView.extend {
        render : () ->
            @$el.html template @model.attributes
            @model.attributes.name
    }

    new ConnectionView()
