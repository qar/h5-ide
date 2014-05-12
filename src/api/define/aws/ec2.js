define(['ApiRequestDefs'], function( ApiRequestDefs ){
	var Apis = {
		'ec2_CreateTags'                         : { url:'/aws/ec2/',	method:'CreateTags',	params:['username', 'session_id', 'region_name', 'resource_ids', 'tags']   },
		'ec2_DeleteTags'                         : { url:'/aws/ec2/',	method:'DeleteTags',	params:['username', 'session_id', 'region_name', 'resource_ids', 'tags']   },
		'ec2_DescribeTags'                       : { url:'/aws/ec2/',	method:'DescribeTags',	params:['username', 'session_id', 'region_name', 'filters']   },
		'ec2_DescribeRegions'                    : { url:'/aws/ec2/',	method:'DescribeRegions',	params:['username', 'session_id', 'region_names', 'filters']   },
		'ec2_DescribeAvailabilityZones'          : { url:'/aws/ec2/',	method:'DescribeAvailabilityZones',	params:['username', 'session_id', 'region_name', 'zone_names', 'filters']   },
		'ami_CreateImage'                        : { url:'/aws/ec2/ami/',	method:'CreateImage',	params:['username', 'session_id', 'region_name', 'instance_id', 'ami_name', 'ami_desc', 'no_reboot', 'bd_mappings']   },
		'ami_RegisterImage'                      : { url:'/aws/ec2/ami/',	method:'RegisterImage',	params:['username', 'session_id', 'region_name', 'ami_name']   },
		'ami_DeregisterImage'                    : { url:'/aws/ec2/ami/',	method:'DeregisterImage',	params:['username', 'session_id', 'region_name', 'ami_id']   },
		'ami_ModifyImageAttribute'               : { url:'/aws/ec2/ami/',	method:'ModifyImageAttribute',	params:['username', 'session_id']   },
		'ami_ResetImageAttribute'                : { url:'/aws/ec2/ami/',	method:'ResetImageAttribute',	params:['username', 'session_id', 'region_name', 'ami_id', 'attribute_name']   },
		'ami_DescribeImageAttribute'             : { url:'/aws/ec2/ami/',	method:'DescribeImageAttribute',	params:['username', 'session_id', 'region_name', 'ami_id', 'attribute_name']   },
		'ami_DescribeImages'                     : { url:'/aws/ec2/ami/',	method:'DescribeImages',	params:['username', 'session_id', 'region_name', 'ami_ids', 'owners', 'executable_by', 'filters']   },
		'ebs_CreateVolume'                       : { url:'/aws/ec2/ebs/volume/',	method:'CreateVolume',	params:['username', 'session_id', 'region_name', 'zone_name', 'snapshot_id', 'volume_size', 'volume_type', 'iops']   },
		'ebs_DeleteVolume'                       : { url:'/aws/ec2/ebs/volume/',	method:'DeleteVolume',	params:['username', 'session_id', 'region_name', 'volume_id']   },
		'ebs_AttachVolume'                       : { url:'/aws/ec2/ebs/volume/',	method:'AttachVolume',	params:['username', 'session_id', 'region_name', 'volume_id', 'instance_id', 'device']   },
		'ebs_DetachVolume'                       : { url:'/aws/ec2/ebs/volume/',	method:'DetachVolume',	params:['username', 'session_id', 'region_name', 'volume_id', 'instance_id', 'device', 'force']   },
		'ebs_DescribeVolumes'                    : { url:'/aws/ec2/ebs/volume/',	method:'DescribeVolumes',	params:['username', 'session_id', 'region_name', 'volume_ids', 'filters']   },
		'ebs_DescribeVolumeAttribute'            : { url:'/aws/ec2/ebs/volume/',	method:'DescribeVolumeAttribute',	params:['username', 'session_id', 'region_name', 'volume_id', 'attribute_name']   },
		'ebs_DescribeVolumeStatus'               : { url:'/aws/ec2/ebs/volume/',	method:'DescribeVolumeStatus',	params:['username', 'session_id', 'region_name', 'volume_ids', 'filters', 'max_result', 'next_token']   },
		'ebs_ModifyVolumeAttribute'              : { url:'/aws/ec2/ebs/volume/',	method:'ModifyVolumeAttribute',	params:['username', 'session_id', 'region_name', 'volume_id', 'auto_enable_IO']   },
		'ebs_EnableVolumeIO'                     : { url:'/aws/ec2/ebs/volume/',	method:'EnableVolumeIO',	params:['username', 'session_id', 'region_name', 'volume_id']   },
		'ebs_CreateSnapshot'                     : { url:'/aws/ec2/ebs/snapshot/',	method:'CreateSnapshot',	params:['username', 'session_id', 'region_name', 'volume_id', 'description']   },
		'ebs_DeleteSnapshot'                     : { url:'/aws/ec2/ebs/snapshot/',	method:'DeleteSnapshot',	params:['username', 'session_id', 'region_name', 'snapshot_id']   },
		'ebs_ModifySnapshotAttribute'            : { url:'/aws/ec2/ebs/snapshot/',	method:'ModifySnapshotAttribute',	params:['username', 'session_id', 'region_name', 'snapshot_id', 'user_ids', 'group_names']   },
		'ebs_ResetSnapshotAttribute'             : { url:'/aws/ec2/ebs/snapshot/',	method:'ResetSnapshotAttribute',	params:['username', 'session_id', 'region_name', 'snapshot_id', 'attribute_name']   },
		'ebs_DescribeSnapshots'                  : { url:'/aws/ec2/ebs/snapshot/',	method:'DescribeSnapshots',	params:['username', 'session_id', 'region_name', 'snapshot_ids', 'owners', 'restorable_by', 'filters']   },
		'ebs_DescribeSnapshotAttribute'          : { url:'/aws/ec2/ebs/snapshot/',	method:'DescribeSnapshotAttribute',	params:['username', 'session_id', 'region_name', 'snapshot_id', 'attribute_name']   },
		'eip_AllocateAddress'                    : { url:'/aws/ec2/elasticip/',	method:'AllocateAddress',	params:['username', 'session_id', 'region_name', 'domain']   },
		'eip_ReleaseAddress'                     : { url:'/aws/ec2/elasticip/',	method:'ReleaseAddress',	params:['username', 'session_id', 'region_name', 'ip', 'allocation_id']   },
		'eip_AssociateAddress'                   : { url:'/aws/ec2/elasticip/',	method:'AssociateAddress',	params:['username']   },
		'eip_DisassociateAddress'                : { url:'/aws/ec2/elasticip/',	method:'DisassociateAddress',	params:['username', 'session_id', 'region_name', 'ip', 'association_id']   },
		'eip_DescribeAddresses'                  : { url:'/aws/ec2/elasticip/',	method:'DescribeAddresses',	params:['username', 'session_id', 'region_name', 'ips', 'allocation_ids', 'filters']   },
		'ins_RunInstances'                       : { url:'/aws/ec2/instance/',	method:'RunInstances',	params:['username']   },
		'ins_StartInstances'                     : { url:'/aws/ec2/instance/',	method:'StartInstances',	params:['username', 'session_id', 'region_name', 'instance_ids']   },
		'ins_StopInstances'                      : { url:'/aws/ec2/instance/',	method:'StopInstances',	params:['username', 'session_id', 'region_name', 'instance_ids', 'force']   },
		'ins_RebootInstances'                    : { url:'/aws/ec2/instance/',	method:'RebootInstances',	params:['username', 'session_id', 'region_name', 'instance_ids']   },
		'ins_TerminateInstances'                 : { url:'/aws/ec2/instance/',	method:'TerminateInstances',	params:['username', 'session_id', 'region_name', 'instance_ids']   },
		'ins_MonitorInstances'                   : { url:'/aws/ec2/instance/',	method:'MonitorInstances',	params:['username', 'session_id', 'region_name', 'instance_ids']   },
		'ins_UnmonitorInstances'                 : { url:'/aws/ec2/instance/',	method:'UnmonitorInstances',	params:['username', 'session_id', 'region_name', 'instance_ids']   },
		'ins_BundleInstance'                     : { url:'/aws/ec2/instance/',	method:'BundleInstance',	params:['username', 'session_id', 'region_name', 'instance_id', 's3_bucket']   },
		'ins_CancelBundleTask'                   : { url:'/aws/ec2/instance/',	method:'CancelBundleTask',	params:['username', 'session_id', 'region_name', 'bundle_id']   },
		'ins_ModifyInstanceAttribute'            : { url:'/aws/ec2/instance/',	method:'ModifyInstanceAttribute',	params:['username']   },
		'ins_ResetInstanceAttribute'             : { url:'/aws/ec2/instance/',	method:'ResetInstanceAttribute',	params:['username', 'session_id', 'region_name', 'instance_id', 'attribute_name']   },
		'ins_ConfirmProductInstance'             : { url:'/aws/ec2/instance/',	method:'ConfirmProductInstance',	params:['username', 'session_id', 'region_name', 'instance_id', 'product_code']   },
		'ins_DescribeInstances'                  : { url:'/aws/ec2/instance/',	method:'DescribeInstances',	params:['username', 'session_id', 'region_name', 'instance_ids', 'filters']   },
		'ins_DescribeInstanceStatus'             : { url:'/aws/ec2/instance/',	method:'DescribeInstanceStatus',	params:['username', 'session_id', 'region_name', 'instance_ids', 'include_all_instances', 'max_results', 'next_token']   },
		'ins_DescribeBundleTasks'                : { url:'/aws/ec2/instance/',	method:'DescribeBundleTasks',	params:['username', 'session_id', 'region_name', 'bundle_ids', 'filters']   },
		'ins_DescribeInstanceAttribute'          : { url:'/aws/ec2/instance/',	method:'DescribeInstanceAttribute',	params:['username', 'session_id', 'region_name', 'instance_id', 'attribute_name']   },
		'ins_GetConsoleOutput'                   : { url:'/aws/ec2/instance/',	method:'GetConsoleOutput',	params:['username', 'session_id', 'region_name', 'instance_id']   },
		'ins_GetPasswordData'                    : { url:'/aws/ec2/instance/',	method:'GetPasswordData',	params:['username', 'session_id', 'region_name', 'instance_id', 'key_data']   },
		'kp_CreateKeyPair'                       : { url:'/aws/ec2/keypair/',	method:'CreateKeyPair',	params:['username', 'session_id', 'region_name', 'key_name']   },
		'kp_DeleteKeyPair'                       : { url:'/aws/ec2/keypair/',	method:'DeleteKeyPair',	params:['username', 'session_id', 'region_name', 'key_name']   },
		'kp_ImportKeyPair'                       : { url:'/aws/ec2/keypair/',	method:'ImportKeyPair',	params:['username', 'session_id', 'region_name', 'key_name', 'key_data']   },
		'kp_DescribeKeyPairs'                    : { url:'/aws/ec2/keypair/',	method:'DescribeKeyPairs',	params:['username', 'session_id', 'region_name', 'key_names', 'filters']   },
		'kp_upload'                              : { url:'/aws/ec2/keypair/',	method:'upload',	params:['username', 'session_id', 'region_name', 'key_name', 'key_data']   },
		'kp_download'                            : { url:'/aws/ec2/keypair/',	method:'download',	params:['username', 'session_id', 'region_name', 'key_name']   },
		'kp_remove'                              : { url:'/aws/ec2/keypair/',	method:'remove',	params:['username', 'session_id', 'region_name', 'key_name']   },
		'kp_list'                                : { url:'/aws/ec2/keypair/',	method:'list',	params:['username', 'session_id', 'region_name']   },
		'pg_CreatePlacementGroup'                : { url:'/aws/ec2/placementgroup/',	method:'CreatePlacementGroup',	params:['username', 'session_id', 'region_name', 'group_name', 'strategy']   },
		'pg_DeletePlacementGroup'                : { url:'/aws/ec2/placementgroup/',	method:'DeletePlacementGroup',	params:['username', 'session_id', 'region_name', 'group_name']   },
		'pg_DescribePlacementGroups'             : { url:'/aws/ec2/placementgroup/',	method:'DescribePlacementGroups',	params:['username', 'session_id', 'region_name', 'group_names', 'filters']   },
		'sg_CreateSecurityGroup'                 : { url:'/aws/ec2/securitygroup/',	method:'CreateSecurityGroup',	params:['username', 'session_id', 'region_name', 'group_name', 'group_desc', 'vpc_id']   },
		'sg_DeleteSecurityGroup'                 : { url:'/aws/ec2/securitygroup/',	method:'DeleteSecurityGroup',	params:['username', 'session_id', 'region_name', 'group_name', 'group_id']   },
		'sg_AuthorizeSecurityGroupIngress'       : { url:'/aws/ec2/securitygroup/',	method:'AuthorizeSecurityGroupIngress',	params:['username']   },
		'sg_RevokeSecurityGroupIngress'          : { url:'/aws/ec2/securitygroup/',	method:'RevokeSecurityGroupIngress',	params:['username']   },
		'sg_DescribeSecurityGroups'              : { url:'/aws/ec2/securitygroup/',	method:'DescribeSecurityGroups',	params:['username', 'session_id', 'region_name', 'group_names', 'group_ids', 'filters']   },
	}

	for ( var i in Apis ) {
		ApiRequestDefs.Defs[ i ] = Apis[ i ];
	}

});
