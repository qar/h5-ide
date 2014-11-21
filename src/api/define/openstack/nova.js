define(['ApiRequestDefs'], function( ApiRequestDefs ){
	var Apis = {
		'os_nova_List'                         : { type:'openstack', url:'/os/nova/v2_0/nova/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_nova_V2_Info'                      : { type:'openstack', url:'/os/nova/v2_0/nova/',	method:'V2_Info',	params:['username', 'session_id', 'region']   },
		'os_nova_V2_Extension'                 : { type:'openstack', url:'/os/nova/v2_0/nova/',	method:'V2_Extension',	params:['username', 'session_id', 'region', 'alias']   },
		'os_nova_V2_Limits'                    : { type:'openstack', url:'/os/nova/v2_0/nova/',	method:'V2_Limits',	params:['username', 'session_id', 'region', 'spec_tenant_id']   },
		'os_aggregate_List'                    : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_aggregate_Info'                    : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'Info',	params:['username', 'session_id', 'region', 'ids']   },
		'os_aggregate_Create'                  : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'Create',	params:['username', 'session_id', 'region', 'aggregate']   },
		'os_aggregate_Delete'                  : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'Delete',	params:['username', 'session_id', 'region', 'aggregate_id']   },
		'os_aggregate_Update'                  : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'Update',	params:['username', 'session_id', 'region', 'aggregate_id', 'specs']   },
		'os_aggregate_SetAggregateMetadata'    : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'SetAggregateMetadata',	params:['username', 'session_id', 'region', 'aggregate_id', 'metadata']   },
		'os_aggregate_AddHost'                 : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'AddHost',	params:['username', 'session_id', 'region', 'aggregate_id', 'host_id']   },
		'os_aggregate_RemoveHost'              : { type:'openstack', url:'/os/nova/v2_0/aggregate/',	method:'RemoveHost',	params:['username', 'session_id', 'region', 'aggregate_id', 'host_id']   },
		'os_cloudpipe_List'                    : { type:'openstack', url:'/os/nova/v2_0/cloudpipe/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_cloudpipe_Create'                  : { type:'openstack', url:'/os/nova/v2_0/cloudpipe/',	method:'Create',	params:['username', 'session_id', 'region', 'project_id']   },
		'os_cloudpipe_Update'                  : { type:'openstack', url:'/os/nova/v2_0/cloudpipe/',	method:'Update',	params:['username', 'session_id', 'region', 'specs']   },
		'os_flavor_List'                       : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'List',	params:['username', 'session_id', 'region', 'min_disk', 'min_ram', 'marker', 'limit']   },
		'os_flavor_Info'                       : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'Info',	params:['username', 'session_id', 'region', 'ids']   },
		'os_flavor_Create'                     : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'Create',	params:['username', 'session_id', 'region', 'flavor']   },
		'os_flavor_ListFlavorTenants'          : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'ListFlavorTenants',	params:['username', 'session_id', 'region', 'flavor_id']   },
		'os_flavor_AddTenantAccess'            : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'AddTenantAccess',	params:['username', 'session_id', 'region', 'flavor_id', 'access']   },
		'os_flavor_RemoveTenantAccess'         : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'RemoveTenantAccess',	params:['username', 'session_id', 'region', 'flavor_id', 'access']   },
		'os_flavor_ListFlavorExtraSpecs'       : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'ListFlavorExtraSpecs',	params:['username', 'session_id', 'region', 'key_id']   },
		'os_flavor_CreateFlavorExtraSpecs'     : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'CreateFlavorExtraSpecs',	params:['username', 'session_id', 'region', 'specs']   },
		'os_flavor_DeleteFlavorExtraSpecs'     : { type:'openstack', url:'/os/nova/v2_0/flavor/',	method:'DeleteFlavorExtraSpecs',	params:['username', 'session_id', 'region', 'key_id']   },
		'os_host_List'                         : { type:'openstack', url:'/os/nova/v2_0/host/',	method:'List',	params:['username', 'session_id', 'region', 'service', 'zone']   },
		'os_host_Info'                         : { type:'openstack', url:'/os/nova/v2_0/host/',	method:'Info',	params:['username', 'session_id', 'region', 'host_names']   },
		'os_hypervisor_List'                   : { type:'openstack', url:'/os/nova/v2_0/hypervisor/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_hypervisor_Info'                   : { type:'openstack', url:'/os/nova/v2_0/hypervisor/',	method:'Info',	params:['username', 'session_id', 'region', 'hypervisor_hostnames', 'list_servers']   },
		'os_hypervisor_Statistics'             : { type:'openstack', url:'/os/nova/v2_0/hypervisor/',	method:'Statistics',	params:['username', 'session_id', 'region']   },
		'os_interface_List'                    : { type:'openstack', url:'/os/nova/v2_0/interface/',	method:'List',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_interface_Info'                    : { type:'openstack', url:'/os/nova/v2_0/interface/',	method:'Info',	params:['username', 'session_id', 'region', 'server_id', 'attachment_ids']   },
		'os_interface_Create'                  : { type:'openstack', url:'/os/nova/v2_0/interface/',	method:'Create',	params:['username', 'session_id', 'region', 'server_id', 'interface']   },
		'os_interface_Delete'                  : { type:'openstack', url:'/os/nova/v2_0/interface/',	method:'Delete',	params:['username', 'session_id', 'region', 'server_id', 'attachment_id']   },
		'os_interface_ListVirtualInterface'    : { type:'openstack', url:'/os/nova/v2_0/interface/',	method:'ListVirtualInterface',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_ip_ListServerAddresses'            : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListServerAddresses',	params:['username', 'session_id', 'region', 'server_id', 'network_label']   },
		'os_ip_ListFixedAddresses'             : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListFixedAddresses',	params:['uesrname', 'session_id', 'region', 'addr_id']   },
		'os_ip_ReserveFixedAddress'            : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ReserveFixedAddress',	params:['username', 'session_id', 'region', 'addr_id']   },
		'os_ip_ListDomainEntries'              : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListDomainEntries',	params:['username', 'session_id', 'region']   },
		'os_ip_ListDNSEntries'                 : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListDNSEntries',	params:['username', 'session_id', 'region', 'domain', 'dns_name', 'dns_ip']   },
		'os_ip_ListFloatingAddressPools'       : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListFloatingAddressPools',	params:['uesrname', 'session_id', 'region']   },
		'os_ip_ListFloatingAddresses'          : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListFloatingAddresses',	params:['username', 'session_id', 'region', 'addr_id']   },
		'os_ip_ListFloatingAddressesBulk'      : { type:'openstack', url:'/os/nova/v2_0/ip/',	method:'ListFloatingAddressesBulk',	params:['username', 'session_id', 'region', 'host_name']   },
		'os_keypair_List'                      : { type:'openstack', url:'/os/nova/v2_0/keypair/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_keypair_Info'                      : { type:'openstack', url:'/os/nova/v2_0/keypair/',	method:'Info',	params:['username', 'session_id', 'region', 'keypair_names']   },
		'os_keypair_Create'                    : { type:'openstack', url:'/os/nova/v2_0/keypair/',	method:'Create',	params:['username', 'session_id', 'region', 'keypair_name', 'public_key']   },
		'os_keypair_Delete'                    : { type:'openstack', url:'/os/nova/v2_0/keypair/',	method:'Delete',	params:['username', 'session_id', 'region', 'keypair_name']   },
		'os_servergroup_List'                  : { type:'openstack', url:'/os/nova/v2_0/servergroup/',	method:'List',	params:['username', 'session_id', 'region']   },
		'os_servergroup_Info'                  : { type:'openstack', url:'/os/nova/v2_0/servergroup/',	method:'Info',	params:['username', 'session_id', 'region', 'ids']   },
		'os_server_List'                       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'List',	params:['username', 'session_id', 'region', 'changes_since', 'image', 'flavor', 'name', 'marker', 'limit', 'status', 'host']   },
		'os_server_Info'                       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'Info',	params:['username', 'session_id', 'region', 'ids']   },
		'os_server_CreateServerMetadata'       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'CreateServerMetadata',	params:['username', 'session_id', 'region', 'server_id', 'metadata']   },
		'os_server_GetServerMetadata'          : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'GetServerMetadata',	params:['username', 'session_id', 'region', 'server_id', 'metadata_key']   },
		'os_server_UpdateServerMetadata'       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'UpdateServerMetadata',	params:['username', 'session_id', 'region', 'server_id', 'metadata']   },
		'os_server_DeleteServerMetadata'       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'DeleteServerMetadata',	params:['username', 'session_id', 'region', 'server_id', 'metadata_key']   },
		'os_server_GetConsoleOutput'           : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'GetConsoleOutput',	params:['username', 'session_id', 'region', 'server_id', 'length']   },
		'os_server_GetVNCConsole'              : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'GetVNCConsole',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_server_GetServerPassword'          : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'GetServerPassword',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_server_DeleteServerPassword'       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'DeleteServerPassword',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_server_GetServerDiagnostics'       : { type:'openstack', url:'/os/nova/v2_0/server/',	method:'GetServerDiagnostics',	params:['username', 'session_id', 'region', 'server_id']   },
		'os_service_List'                      : { type:'openstack', url:'/os/nova/v2_0/service/',	method:'List',	params:['username', 'session_id', 'region', 'is_disabled']   },
		'os_v2_CreateRootCertificate'          : { type:'openstack', url:'/os/nova/v2_0/v2/',	method:'CreateRootCertificate',	params:['username', 'session_id', 'region']   },
		'os_v2_GetRootCertificate'             : { type:'openstack', url:'/os/nova/v2_0/v2/',	method:'GetRootCertificate',	params:['username', 'session_id', 'region']   },
		'os_v2_ListTenantUsage'                : { type:'openstack', url:'/os/nova/v2_0/v2/',	method:'ListTenantUsage',	params:['username', 'session_id', 'region', 'spec_tenant_id']   },
	}

	for ( var i in Apis ) {
		/* env:dev */
		if (ApiRequestDefs.Defs[ i ]){
			console.warn('api duplicate: ' + i);
		}
		/* env:dev:end */
		ApiRequestDefs.Defs[ i ] = Apis[ i ];
	}

});
