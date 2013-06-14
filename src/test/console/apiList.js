var API_DATA_LIST = {Forge:{Log:{put_user_log:{method:'/log:put_user_log',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},user_logs:{type:'String',value:'null'}}}},Public:{get_hostname:{method:'/public:get_hostname',param:{region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'}}},get_dns_ip:{method:'/public:get_dns_ip',param:{region_name:{type:'String',value:'null'}}}},Request:{init:{method:'/request:init',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}},update:{method:'/request:update',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},timestamp:{type:'String',value:'null'}}}},Session:{login:{method:'/session:login',param:{username:{type:'String',value:'null'},password:{type:'String',value:'null'}}},logout:{method:'/session:logout',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},set_credential:{method:'/session:set_credential',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},access_key:{type:'String',value:'null'},secret_key:{type:'String',value:'null'},account_id:{type:'String',value:'null'}}},guest:{method:'/session:guest',param:{guest_id:{type:'String',value:'null'},guestname:{type:'String',value:'null'}}}},App:{create:{method:'/app:create',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},spec:{type:'String',value:'null'}}},update:{method:'/app:update',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},spec:{type:'String',value:'null'},app_id:{type:'String',value:'null'}}},rename:{method:'/app:rename',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'},new_name:{type:'String',value:'null'},app_name:{type:'String',value:'null'}}},terminate:{method:'/app:terminate',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'},app_name:{type:'String',value:'null'}}},start:{method:'/app:start',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'},app_name:{type:'String',value:'null'}}},stop:{method:'/app:stop',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'},app_name:{type:'String',value:'null'}}},reboot:{method:'/app:reboot',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'},app_name:{type:'String',value:'null'}}},info:{method:'/app:info',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_ids:{type:'Array',value:'null'}}},list:{method:'/app:list',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_ids:{type:'Array',value:'null'}}},resource:{method:'/app:resource',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},app_id:{type:'String',value:'null'}}},summary:{method:'/app:summary',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}}},Favorite:{add:{method:'/favorite:add',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},resource:{type:'String',value:'null'}}},remove:{method:'/favorite:remove',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},resource_ids:{type:'Array',value:'null'}}},info:{method:'/favorite:info',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},provider:{type:'String',value:'null'},service:{type:'String',value:'null'},resource:{type:'String',value:'null'}}}},Guest:{invite:{method:'/guest:invite',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}},cancel:{method:'/guest:cancel',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},guest_id:{type:'String',value:'null'}}},access:{method:'/guest:access',param:{guestname:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},guest_id:{type:'String',value:'null'}}},end:{method:'/guest:end',param:{guestname:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},guest_id:{type:'String',value:'null'}}},info:{method:'/guest:info',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},guest_id:{type:'String',value:'null'}}}},Stack:{create:{method:'/stack:create',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},spec:{type:'String',value:'null'}}},remove:{method:'/stack:remove',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_id:{type:'String',value:'null'},stack_name:{type:'String',value:'null'}}},save:{method:'/stack:save',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},spec:{type:'String',value:'null'}}},rename:{method:'/stack:rename',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_id:{type:'String',value:'null'},new_name:{type:'String',value:'null'},stack_name:{type:'String',value:'null'}}},run:{method:'/stack:run',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_id:{type:'String',value:'null'},app_name:{type:'String',value:'null'},app_desc:{type:'String',value:'null'},app_component:{type:'String',value:'null'},app_property:{type:'String',value:'null'},app_layout:{type:'String',value:'null'},stack_name:{type:'String',value:'null'}}},save_as:{method:'/stack:save_as',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_id:{type:'String',value:'null'},new_name:{type:'String',value:'null'},stack_name:{type:'String',value:'null'}}},info:{method:'/stack:info',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_ids:{type:'Array',value:'null'}}},list:{method:'/stack:list',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},stack_ids:{type:'Array',value:'null'}}}}},AWSUtil:{AWS:{quickstart:{method:'/aws:quickstart',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}},public:{method:'/aws:public',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}},info:{method:'/aws:info',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}},resource:{method:'/aws:resource',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},resources:{type:'String',value:'null'}}},price:{method:'/aws:price',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},status:{method:'/aws:status',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}}}},EC2:{AMI:{CreateImage:{method:'/aws/ec2/ami:CreateImage',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},ami_name:{type:'String',value:'null'},ami_desc:{type:'String',value:'null'},no_reboot:{type:'String',value:'null'},bd_mappings:{type:'String',value:'null'}}},RegisterImage:{method:'/aws/ec2/ami:RegisterImage',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ami_name:{type:'String',value:'null'},ami_desc:{type:'String',value:'null'}}},DeregisterImage:{method:'/aws/ec2/ami:DeregisterImage',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ami_id:{type:'String',value:'null'}}},ModifyImageAttribute:{method:'/aws/ec2/ami:ModifyImageAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},ResetImageAttribute:{method:'/aws/ec2/ami:ResetImageAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ami_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},DescribeImageAttribute:{method:'/aws/ec2/ami:DescribeImageAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ami_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},DescribeImages:{method:'/aws/ec2/ami:DescribeImages',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ami_ids:{type:'Array',value:'null'},owners:{type:'Array',value:'null'},executable_by:{type:'String',value:'null'},filters:{type:'Array',value:'null'}}}},EBS:{CreateVolume:{method:'/aws/ebs/volume:CreateVolume',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},zone_name:{type:'String',value:'null'},snapshot_id:{type:'String',value:'null'},volume_size:{type:'int',value:'null'},volume_type:{type:'String',value:'null'},iops:{type:'String',value:'null'}}},DeleteVolume:{method:'/aws/ebs/volume:DeleteVolume',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'}}},AttachVolume:{method:'/aws/ebs/volume:AttachVolume',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},device:{type:'String',value:'null'}}},DetachVolume:{method:'/aws/ebs/volume:DetachVolume',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},device:{type:'String',value:'null'},force:{type:'Boolean',value:'null'}}},DescribeVolumes:{method:'/aws/ebs/volume:DescribeVolumes',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeVolumeAttribute:{method:'/aws/ebs/volume:DescribeVolumeAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},DescribeVolumeStatus:{method:'/aws/ebs/volume:DescribeVolumeStatus',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'},max_result:{type:'String',value:'null'},next_token:{type:'String',value:'null'}}},ModifyVolumeAttribute:{method:'/aws/ebs/volume:ModifyVolumeAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'},auto_enable_IO:{type:'String',value:'null'}}},EnableVolumeIO:{method:'/aws/ebs/volume:EnableVolumeIO',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'}}},CreateSnapshot:{method:'/aws/ebs/snapshot:CreateSnapshot',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},volume_id:{type:'String',value:'null'},description:{type:'String',value:'null'}}},DeleteSnapshot:{method:'/aws/ebs/snapshot:DeleteSnapshot',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},snapshot_id:{type:'String',value:'null'}}},ModifySnapshotAttribute:{method:'/aws/ebs/snapshot:ModifySnapshotAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},snapshot_id:{type:'String',value:'null'},user_ids:{type:'Array',value:'null'},group_names:{type:'Array',value:'null'}}},ResetSnapshotAttribute:{method:'/aws/ebs/snapshot:ResetSnapshotAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},snapshot_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},DescribeSnapshots:{method:'/aws/ebs/snapshot:DescribeSnapshots',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},snapshot_ids:{type:'Array',value:'null'},owners:{type:'Array',value:'null'},restorable_by:{type:'String',value:'null'},filters:{type:'Array',value:'null'}}},DescribeSnapshotAttribute:{method:'/aws/ebs/snapshot:DescribeSnapshotAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},snapshot_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}}},EC2:{CreateTags:{method:'/aws/ec2:CreateTags',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},resource_ids:{type:'Array',value:'null'},tags:{type:'Array',value:'null'}}},DeleteTags:{method:'/aws/ec2:DeleteTags',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},resource_ids:{type:'Array',value:'null'},tags:{type:'Array',value:'null'}}},DescribeTags:{method:'/aws/ec2:DescribeTags',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},filters:{type:'Array',value:'null'}}},DescribeRegions:{method:'/aws/ec2:DescribeRegions',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_names:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeAvailabilityZones:{method:'/aws/ec2:DescribeAvailabilityZones',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},zone_names:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},EIP:{AllocateAddress:{method:'/aws/ec2/eip:AllocateAddress',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},domain:{type:'String',value:'null'}}},ReleaseAddress:{method:'/aws/ec2/eip:ReleaseAddress',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ip:{type:'String',value:'null'},allocation_id:{type:'String',value:'null'}}},AssociateAddress:{method:'/aws/ec2/eip:AssociateAddress',param:{username:{type:'String',value:'null'}}},DisassociateAddress:{method:'/aws/ec2/eip:DisassociateAddress',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ip:{type:'String',value:'null'},association_id:{type:'String',value:'null'}}},DescribeAddresses:{method:'/aws/ec2/eip:DescribeAddresses',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},ips:{type:'Array',value:'null'},allocation_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},Instance:{RunInstances:{method:'/aws/ec2/instance:RunInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},StartInstances:{method:'/aws/ec2/instance:StartInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},StopInstances:{method:'/aws/ec2/instance:StopInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'},force:{type:'Boolean',value:'null'}}},RebootInstances:{method:'/aws/ec2/instance:RebootInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},TerminateInstances:{method:'/aws/ec2/instance:TerminateInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},MonitorInstances:{method:'/aws/ec2/instance:MonitorInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},UnmonitorInstances:{method:'/aws/ec2/instance:UnmonitorInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},BundleInstance:{method:'/aws/ec2/instance:BundleInstance',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},s3_bucket:{type:'String',value:'null'}}},CancelBundleTask:{method:'/aws/ec2/instance:CancelBundleTask',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},bundle_id:{type:'String',value:'null'}}},ModifyInstanceAttribute:{method:'/aws/ec2/instance:ModifyInstanceAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},ResetInstanceAttribute:{method:'/aws/ec2/instance:ResetInstanceAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},ConfirmProductInstance:{method:'/aws/ec2/instance:ConfirmProductInstance',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},product_code:{type:'String',value:'null'}}},DescribeInstances:{method:'/aws/ec2/instance:DescribeInstances',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeInstanceStatus:{method:'/aws/ec2/instance:DescribeInstanceStatus',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'},include_all_instances:{type:'String',value:'null'},max_results:{type:'String',value:'null'},next_token:{type:'String',value:'null'}}},DescribeBundleTasks:{method:'/aws/ec2/instance:DescribeBundleTasks',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},bundle_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeInstanceAttribute:{method:'/aws/ec2/instance:DescribeInstanceAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},GetConsoleOutput:{method:'/aws/ec2/instance:GetConsoleOutput',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'}}},GetPasswordData:{method:'/aws/ec2/instance:GetPasswordData',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},instance_id:{type:'String',value:'null'},key_data:{type:'String',value:'null'}}}},KeyPair:{CreateKeyPair:{method:'/aws/ec2/keypair:CreateKeyPair',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'}}},DeleteKeyPair:{method:'/aws/ec2/keypair:DeleteKeyPair',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'}}},ImportKeyPair:{method:'/aws/ec2/keypair:ImportKeyPair',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'},key_data:{type:'String',value:'null'}}},DescribeKeyPairs:{method:'/aws/ec2/keypair:DescribeKeyPairs',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_names:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},upload:{method:'/aws/ec2/keypair:upload',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'},key_data:{type:'String',value:'null'}}},download:{method:'/aws/ec2/keypair:download',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'}}},remove:{method:'/aws/ec2/keypair:remove',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},key_name:{type:'String',value:'null'}}},list:{method:'/aws/ec2/keypair:list',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'}}}},PlacementGroup:{CreatePlacementGroup:{method:'/aws/ec2/placementgroup:CreatePlacementGroup',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_name:{type:'String',value:'null'},strategy:{type:'String',value:'null'}}},DeletePlacementGroup:{method:'/aws/ec2/placementgroup:DeletePlacementGroup',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_name:{type:'String',value:'null'}}},DescribePlacementGroups:{method:'/aws/ec2/placementgroup:DescribePlacementGroups',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_names:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},SecurityGroup:{CreateSecurityGroup:{method:'/aws/ec2/securitygroup:CreateSecurityGroup',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_name:{type:'String',value:'null'},group_desc:{type:'String',value:'null'},vpc_id:{type:'String',value:'null'}}},DeleteSecurityGroup:{method:'/aws/ec2/securitygroup:DeleteSecurityGroup',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_name:{type:'String',value:'null'},group_id:{type:'String',value:'null'}}},AuthorizeSecurityGroupIngress:{method:'/aws/ec2/securitygroup:AuthorizeSecurityGroupIngress',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},RevokeSecurityGroupIngress:{method:'/aws/ec2/securitygroup:RevokeSecurityGroupIngress',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'}}},DescribeSecurityGroups:{method:'/aws/ec2/securitygroup:DescribeSecurityGroups',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},group_names:{type:'Array',value:'null'},group_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}}},ELB:{ELB:{DescribeInstanceHealth:{method:'/aws/elb:DescribeInstanceHealth',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},elb_name:{type:'String',value:'null'},instance_ids:{type:'Array',value:'null'}}},DescribeLoadBalancerPolicies:{method:'/aws/elb:DescribeLoadBalancerPolicies',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},elb_name:{type:'String',value:'null'},policy_names:{type:'Array',value:'null'}}},DescribeLoadBalancerPolicyTypes:{method:'/aws/elb:DescribeLoadBalancerPolicyTypes',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},policy_type_names:{type:'Array',value:'null'}}},DescribeLoadBalancers:{method:'/aws/elb:DescribeLoadBalancers',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},elb_names:{type:'Array',value:'null'},marker:{type:'String',value:'null'}}}}},IAM:{IAM:{GetServerCertificate:{method:'/aws/iam:GetServerCertificate',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},servercer_name:{type:'String',value:'null'}}},ListServerCertificates:{method:'/aws/iam:ListServerCertificates',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},marker:{type:'String',value:'null'},max_items:{type:'int',value:'null'},path_prefix:{type:'String',value:'null'}}}}},VPC:{ACL:{DescribeNetworkAcls:{method:'/aws/vpc/acl:DescribeNetworkAcls',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},acl_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},CustomerGateway:{DescribeCustomerGateways:{method:'/aws/vpc/cgw:DescribeCustomerGateways',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},gw_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},DHCP:{DescribeDhcpOptions:{method:'/aws/vpc/dhcp:DescribeDhcpOptions',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},dhcp_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},ENI:{DescribeNetworkInterfaces:{method:'/aws/vpc/eni:DescribeNetworkInterfaces',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},eni_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeNetworkInterfaceAttribute:{method:'/aws/vpc/eni:DescribeNetworkInterfaceAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},eni_id:{type:'String',value:'null'},attribute:{type:'String',value:'null'}}}},InternetGateway:{DescribeInternetGateways:{method:'/aws/vpc/igw:DescribeInternetGateways',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},gw_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},RouteTable:{DescribeRouteTables:{method:'/aws/vpc/routetable:DescribeRouteTables',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},rt_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},Subnet:{DescribeSubnets:{method:'/aws/vpc/subnet:DescribeSubnets',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},subnet_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},VPC:{DescribeVpcs:{method:'/aws/vpc:DescribeVpcs',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},vpc_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}},DescribeAccountAttributes:{method:'/aws/vpc:DescribeAccountAttributes',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},attribute_name:{type:'Array',value:'null'}}},DescribeVpcAttribute:{method:'/aws/vpc:DescribeVpcAttribute',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},vpc_id:{type:'String',value:'null'},attribute:{type:'String',value:'null'}}}},VPNGateway:{DescribeVpnGateways:{method:'/aws/vpc/vgw:DescribeVpnGateways',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},gw_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}},VPN:{DescribeVpnConnections:{method:'/aws/vpc/vpn:DescribeVpnConnections',param:{username:{type:'String',value:'null'},session_id:{type:'String',value:'null'},region_name:{type:'String',value:'null'},vpn_ids:{type:'Array',value:'null'},filters:{type:'Array',value:'null'}}}}}};