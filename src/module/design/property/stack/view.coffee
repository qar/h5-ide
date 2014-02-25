#############################
#  View(UI logic) for design/property/stack
#############################

define [ '../base/view',
         'text!./template/stack.html',
         'text!./template/acl.html',
         'text!./template/sub.html',
         'event'
], ( PropertyView, template, acl_template, sub_template, ide_event ) ->

    template     = Handlebars.compile template
    acl_template = Handlebars.compile acl_template
    sub_template = Handlebars.compile sub_template

    StackView = PropertyView.extend {
        events   :
            'change #property-stack-name'          : 'stackNameChanged'

            'click #stack-property-new-acl'        : 'createAcl'
            'click #stack-property-acl-list .edit' : 'openAcl'
            'click .sg-list-delete-btn'            : 'deleteAcl'

            'click #property-sub-list .icon-edit' : 'editSNS'
            'click #property-sub-list .icon-del'  : 'delSNS'
            'click #property-create-asg'          : 'openSNSModal'

            'click #property-stack-ops-option input' : 'opsOptionChanged'

        render     : () ->

            t = template
            if @model.isApp or @model.isAppEdit
                if @model.attributes.isImport
                    str = '<header class="property-sidebar-title sidebar-title truncate" id="property-title">Visualization - '+@model.attributes.vpcid+'<i class="icon-info tooltip property-header-info" data-tooltip="Currently you can rearrange the layout of visualisation and export it as PNG image file. Future version will include the feature to import VPC resource as an app. "></i></header>'
                    $('#property-title').html(str)
                else
                    title = "App - #{@model.get('name')}"
            else
                title = "Stack - #{@model.get('name')}"

            @$el.html( template( @model.attributes ) )

            if title
                @setTitle( title )

            @refreshACLList()

            if not @model.isApp
                @updateSNSList @model.get("subscription"), true

            null

        stackNameChanged : () ->
            stackNameInput = $ '#property-stack-name'
            stackId = @model.get( 'id' )
            name = stackNameInput.val()

            stackNameInput.parsley 'custom', ( val ) ->
                if not MC.validate 'awsName',  val
                    return 'This value should be a valid Stack name.'

                if not MC.aws.aws.checkStackName stackId, val
                    return "Stack name \" #{name} \" is already in using. Please use another one."

            if stackNameInput.parsley 'validate'
                @trigger 'STACK_NAME_CHANGED', name
                @setTitle "Stack - " + name
            null

        refreshACLList : () ->
            $('#stack-property-acl-list').html acl_template @model.attributes

        createAcl : ()->
            @trigger "OPEN_ACL", @model.createAcl()

        openAcl : ( event ) ->
            @trigger "OPEN_ACL", $(event.currentTarget).closest("li").attr("data-uid")
            null

        updateSNSList : ( snslist_data, textOnly ) ->

            hasASG = @model.get("has_asg")

            # Hide all message
            $(".property-sns-info").children().hide()

            if not snslist_data or not snslist_data.length
                if hasASG
                    $("#property-sns-no-sub").show()
                else
                    $("#property-sns-no-sub-no-asg").show()
            else if not hasASG
                $("#property-sns-no-asg").show()

            if textOnly
                return

            # Remove Old Stuff
            $list = $("#property-sub-list")
            $list.find("li:not(.hide)").remove()

            # Insert New List
            $template = $list.find(".hide")
            for sub in snslist_data
                $clone = $template.clone().removeClass("hide").appendTo $list

                $clone.attr "data-uid", sub.id
                $clone.find(".protocol").html sub.protocol
                $clone.find(".endpoint").html sub.endpoint

            $("#property-stack-sns-num").html( snslist_data.length )

            null

        delSNS : ( event ) ->

            $li = $(event.currentTarget).closest("li")
            uid = $li.attr("data-uid")
            $li.remove()

            @updateSNSList $("#property-sub-list").children(":not(.hide)"), true

            @model.deleteSNS uid

        editSNS : ( event ) ->
            $sub_li = $( event.currentTarget ).closest("li")
            data =
                title    : "Edit"
                uid      : $sub_li.attr("data-uid")
                protocol : $sub_li.find(".protocol").text()
                endpoint : $sub_li.find(".endpoint").text()

            @openSNSModal event, data
            null

        saveSNS : ( data ) ->

            if data.uid
                # We are editing existing Subscription
                # Update the related subscription's dom
                $dom = $("#property-sub-list").children("li[data-uid='#{data.uid}']")
                $dom.find(".protocol").html( data.protocol )
                $dom.find(".endpoint").html( data.endpoint )

            @model.addSubscription data

            if !data.uid
                # Update the list
                @updateSNSList @model.get("subscription")

        openSNSModal : ( event, data ) ->
            # data =
            #       uid : "123123-123123-123123"
            #       protocol : "Email"
            #       endpoint : "123@abc.com"
            if !data
                data =
                    protocol : "email"
                    title    : "Add"

            modal sub_template data

            $modal = $("#property-asg-sns-modal")

            # Setup the protocol
            $modal.find(".dropdown").find(".item").each ()->
                if $(this).data("id") is data.protocol
                    $(this).addClass("selected").parent().siblings().text( $(this).text() )

            # Setup the endpoint
            updateEndpoint = ( protocol ) ->
                $input  = $(".property-asg-ep")#.removeClass("https http")
                switch $modal.find(".selected").data("id")

                    when "sqs"
                        placeholder = "Amazon ARN"
                        type        = 'sqs'
                        errorMsg    = 'Please provide a valid Amazon SQS ARN'

                    when "arn"
                        placeholder = "Amazon ARN"
                        type        = 'arn'
                        errorMsg    = 'Please provide a valid Application ARN'

                    when "email"
                        placeholder = "example@acme.com"
                        type        = 'email'
                        errorMsg    = 'Please provide a valid email address'

                    when "email-json"
                        placeholder = "example@acme.com"
                        type        = 'email'
                        errorMsg    = 'Please provide a valid email address'

                    when "sms"
                        placeholder = "e.g. 1-206-555-6423"
                        type        = 'usPhone'
                        errorMsg    = 'Please provide a valid phone number (currently only support US phone number)'

                    when "http"
                        #$input.addClass "http"
                        placeholder = "http://www.example.com"
                        type        = 'http'
                        errorMsg    = 'Please provide a valid URL'

                    when "https"
                        #$input.addClass "https"
                        placeholder = "https://www.example.com"
                        type        = 'https'
                        errorMsg    = 'Please provide a valid URL'

                endPoint = $ '#property-asg-endpoint'
                endPoint.attr "placeholder", placeholder

                endPoint.parsley 'custom', ( value ) ->
                    if type and value and ( not MC.validate type, value )
                        return errorMsg

                if endPoint.val().length
                    endPoint.parsley 'validate'
                null

            updateEndpoint()

            $modal.on "OPTION_CHANGE", updateEndpoint


            # Bind Events
            self = this
            $("#property-asg-sns-done").on "click", ()->
                endPoint = $("#property-asg-endpoint")

                if endPoint.parsley 'validate'
                    data =
                        uid      : $modal.attr("data-uid")
                        protocol : $modal.find(".selected").data("id")
                        endpoint : endPoint.val()

                    modal.close()

                    self.saveSNS data

                null

        deleteAcl : (event) ->

            $target  = $( event.currentTarget )
            assoCont = parseInt $target.attr('data-count'), 10
            aclUID   = $target.closest("li").attr('data-uid')

            # show dialog to confirm that delete acl
            if assoCont
                that    = this
                aclName = $target.attr('data-name')

                dialog_template = MC.template.modalDeleteSGOrACL {
                    title : 'Delete Network ACL'
                    main_content : "Are you sure you want to delete #{aclName}?"
                    desc_content : "Subnets associated with #{aclName} will use DefaultACL."
                }
                modal dialog_template, false, () ->
                    $('#modal-confirm-delete').click () ->
                        that.model.removeAcl( aclUID )
                        that.refreshACLList()
                        modal.close()
            else
                @model.removeAcl( aclUID )
                @refreshACLList()

        opsOptionChanged : (event) ->

            thatModel = @model
            value = $('#property-stack-ops-option input:checked').val()
            if value is 'property-stack-ops-enable'
                # $('#property-stack-ops-enable-info').show()
                notShowModal = thatModel.isAllInstanceNotHaveUserData()
                if not notShowModal
                    # if have any userdata in any instance
                    $('#property-stack-ops-disable').prop('checked', 'checked')
                    modal MC.template.modalStackAgentEnable({})
                    $('#modal-stack-agent-enable-confirm').one 'click', ()->
                        $('#property-stack-ops-enable').prop('checked', 'checked')
                        thatModel.setAgentEnable(true)
                        modal.close()
                else
                    thatModel.setAgentEnable(true)
            else
                # $('#property-stack-ops-enable-info').hide()
                thatModel.setAgentEnable(false)
    }

    new StackView()
  