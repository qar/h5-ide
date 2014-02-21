#############################
#  View(UI logic) for design/property/instacne
#############################

define [ '../base/view',
         '../instance/view'
         'text!./template/app.html',
         'text!./template/ami_list.html',
         'i18n!nls/lang.js'
], ( PropertyView, instance_view, template, ami_list_template, lang ) ->

    template          = Handlebars.compile template
    ami_list_template = Handlebars.compile ami_list_template

    InstanceView = PropertyView.extend {

        events :
            'change #property-instance-count'     : "countChange"
            'click #property-ami'                 : "openAmiPanel"

            'OPTION_CHANGE #instance-type-select'     : "instanceTypeSelect"
            'change #property-instance-ebs-optimized' : 'ebsOptimizedSelect'

            'click .toggle-eip'                         : 'setEip'
            'click #instance-ip-add'                    : "addIp"
            'click #property-network-list .icon-remove' : "removeIp"
            'change .input-ip'                          : 'syncIPList'



        render : ( ) ->
            # Render
            @$el.html template @model.attributes

            @updateInstanceList()
            @refreshIPList()

            # Return title of property
            @model.attributes.name

        openAmiPanel : ( event ) ->
            this.trigger "OPEN_AMI", $( event.currentTarget ).data("uid")
            false

        updateInstanceList : () ->
            $("#prop-appedit-ami-list").html ami_list_template @model.attributes
            null

        countChange : ( event ) ->
            target = $ event.currentTarget

            target.parsley 'custom', ( val ) ->
                if isNaN( val ) or val > 99 or val < 1
                    return 'This value must be >= 1 and <= 99'

            if not target.parsley 'validate'
                return

            val = +target.val()
            @model.setCount val

            @updateInstanceList()
            @setEditableIP( val is 1 )
            null

        ebsOptimizedSelect : ( event )->
            @model.setEbsOptimized event.target.checked
            null

        instanceTypeSelect  : instance_view.instanceTypeSelect

        addIp               : instance_view.addIp
        removeIp            : instance_view.removeIp
        setEip              : instance_view.setEip
        syncIPList          : instance_view.syncIPList
        refreshIPList       : instance_view.refreshIPList
        updateIPAddBtnState : instance_view.updateIPAddBtnState
        setEditableIP       : instance_view.setEditableIP
        validateIpItem      : instance_view.validateIpItem


    }

    new InstanceView()
