#############################
#  View(UI logic) for design/property/acl
#############################

define [ 'event', 'backbone', 'jquery', 'handlebars' ], ( ide_event ) ->

   ACLView = Backbone.View.extend {

        el       : $ document
        tagName  : $ '.property-details'
        ruleTpl  : null

        initialize : ->
            #handlebars equal logic
            Handlebars.registerHelper 'ifCond', (v1, v2, options) ->
                if v1 is v2
                    return options.fn this
                options.inverse this

            null

        events   :
            'click .secondary-panel .back' : 'returnMainPanel'
            'click #acl-add-rule-icon' : 'showCreateRuleModal'
            'click #acl-modal-rule-save-btn' : 'saveRule'

        instance_expended_id : 0

        render     : (expended_accordion_id, template, rule_template, attributes) ->
            console.log 'property:acl render'
            htmlTpl = Handlebars.compile template

            $('#acl-secondary-panel-wrap').html htmlTpl(attributes)

            this.ruleTpl = Handlebars.compile rule_template

            $('#acl-secondary-panel-wrap .acl-rules').html this.ruleTpl(attributes)

            this.instance_expended_id = expended_accordion_id

            secondary_panel_wrap = $('#acl-secondary-panel-wrap')

            fixedaccordion.resize()

            secondary_panel_wrap.animate({
                right: 0
            }, {
                duration: 200,
                specialEasing: {
                    width: 'linear'
                },
                complete : () ->

                }
            )

        returnMainPanel : () ->
            me = this
            console.log 'returnMainPanel'
            secondary_panel_wrap = $('#acl-secondary-panel-wrap')
            secondary_panel_wrap.animate({
                right: "-280px"
            }, {
                duration: 200,
                specialEasing: {
                    width: 'linear'
                },
                complete : () ->
                    # ide_event.trigger ide_event.OPEN_PROPERTY, 'component', $('#sg-secondary-panel').attr('parent'), me.instance_expended_id
                }
            )

        showCreateRuleModal : () ->
            modal MC.template.modalAddACL {}, true
            scrollbar.init()
            return false

        saveRule : () ->

            ruleNumber = $('#modal-acl-number').val()
            action = $('#acl-add-model-action-allow').prop('checked')
            inboundDirection = $('#acl-add-model-direction-inbound').prop('checked')
            source = $.trim($('#acl-add-model-source-select').find('.selection').text())
            protocol = $.trim($('#acl-rule-modal-protocol-select').find('.selection').text())
            port = $('#acl-rule-modal-port-input').val()

            this.trigger 'ADD_RULE_TO_ACL', {
                rule: ruleNumber,
                action: action,
                inbound: inboundDirection,
                source: source,
                protocol: protocol,
                port: port
            }

            $('#modal-wrap').trigger('closed').remove()

            null

        refreshRuleList : (uid, value) ->
            $('#acl-secondary-panel-wrap .acl-rules').html this.ruleTpl({
                component: value
            })
    }

    view = new ACLView()

    return view