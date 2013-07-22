#############################
#  View(UI logic) for design/property/vpc
#############################

define [ 'event', 'backbone', 'jquery', 'handlebars', 'underscore'
        'UI.fixedaccordion' ], ( ide_event ) ->

    # Helpers
    mapFilterInput = ( selector ) ->
        $inputs = $( selector )
        result  = []

        for ipt in $inputs
            if ipt.value
                result.push ipt.value

        if result.length == 0 then null else result

    updateAmazonCB = ( evt ) ->
        rowLength = $( evt.target ).children().length
        if rowLength > 3
            $( '#property-amazon-dns' ).attr( "disabled", true )
        else
            $( '#property-amazon-dns' ).removeAttr( "disabled" )


    VPCView = Backbone.View.extend {

        el       : $ document
        tagName  : $ '.property-details'

        template : Handlebars.compile $( '#property-vpc-tmpl' ).html()

        events   :
            'change #property-vpc-name'       : 'onChangeName'
            'change #property-cidr-block'     : 'onChangeCidr'
            'change #property-dns-resolution' : 'onChangeDnsSupport'
            'change #property-dns-hostname'   : 'onChangeDnsHostname'
            'OPTION_CHANGE #property-tenancy' : 'onChangeTenancy'

            'click .property-dhcp input'      : 'onChangeDhcp'
            'click #property-amazon-dns'      : 'onChangeAmazonDns'

            'change .property-control-group-sub .input' : 'onChangeDhcpOptions'
            'OPTION_CHANGE #property-netbios-type'      : 'onChangeDhcpOptions'
            'REMOVE_ROW #property-dhcp-options'         : 'onChangeDhcpOptions'

        render   : ( attributes ) ->

            this.uid = attributes.uid

            selectedType = attributes.dhcp.netbiosType || 0
            attributes.dhcp.netbiosTypes = [
                  { id : "default" , value : "Not specified", selected : selectedType == 0 }
                , { id : 1 , value : 1, selected : selectedType == 1 }
                , { id : 2 , value : 2, selected : selectedType == 2 }
                , { id : 4 , value : 4, selected : selectedType == 4 }
                , { id : 8 , value : 8, selected : selectedType == 8 }
            ]

            $( '.property-details' ).html this.template attributes
            $( '#property-domain-server' ).on( 'ADD_ROW REMOVE_ROW', updateAmazonCB )

            fixedaccordion.resize()

        onChangeName : ( event ) ->
            console.log "Name Cahanged"
            $( '#property-title' ).html event.target.value
            this.trigger "CHANGE_NAME", event.target.value
            null

        onChangeCidr : ( event ) ->
            this.trigger "CHANGE_CIDR", event.target.value
            null

        onChangeTenancy : ( event, newValue ) ->
            $("#desc-dedicated").toggle( newValue == "dedicated" )

            this.model.setTenancy this.uid, newValue
            null

        onChangeDnsSupport : ( event ) ->
            this.model.setDnsSupport this.uid, event.target.checked
            null

        onChangeDnsHostname : ( event ) ->
            this.model.setDnsHosts this.uid, event.target.checked
            null

        onChangeDhcp : ( event ) ->

            $selectOption = $(".property-dhcp input:checked")

            noDhcp = $selectOption.attr("id") == "property-dhcp-none"

            $("#property-dhcp-desc").toggle    noDhcp
            $("#property-dhcp-options").toggle !noDhcp

            this.model.setDhcp this.uid, !noDhcp

            if noDhcp
                this.notChangingDHCP = true
                # User select none DHCP option.
                # Need to reset everything here.
                $("#property-dhcp-options .multi-ipt-row:not(:first-child)").remove()
                $("#property-dhcp-options .multi-ipt-row .input").val("")
                $("#property-dhcp-domain").val( this.model.defaultDomainName this.uid )
                $("#property-amazon-dns").prop("checked", true)
                $("#property-netbios-type .dropdown-menu li:first-child a").click()
                this.notChangingDHCP = false

            null

        onChangeAmazonDns : ( event ) ->
            useAmazonDns = $("#property-amazon-dns").is(":checked")
            allowRows    = if useAmazonDns then 3 else 4
            $inputbox    = $("#property-domain-server").attr( "data-max-row", allowRows )
            $rows        = $inputbox.children()
            $inputbox.toggleClass "max", $rows.length >= allowRows
            null

        onChangeDhcpOptions : ( event ) ->

            if this.notChangingDHCP
                return

            # Gather all the infomation to submit
            data =
                domainName     : $("#property-dhcp-domain").val()
                useAmazonDns   : $("#property-amazon-dns").is(":checked")
                domainServers  : mapFilterInput "#property-domain-server .input"
                ntpServers     : mapFilterInput "#property-ntp-server .input"
                netbiosServers : mapFilterInput "#property-netbios-server .input"
                netbiosType    : parseInt( $("#property-netbios-type .cur-value").html(), 10 ) || 0

            console.log "DHCP Options Changed", data

            this.model.setDHCPOptions this.uid, data
            null


        setName : ( name ) ->
            $( "#property-vpc-name" ).val name
            $( "#property-title" ).val name

        setCIDR : ( cidr ) ->
            $( "#property-cidr-block" ).val cidr
    }

    view = new VPCView()

    return view
