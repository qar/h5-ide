# Reference: https://trello.com/c/KaOjDSm7/303-orginize-lang-source-coffee

module.exports =
  TA:

   ##### Trust Advisor

    # VPC
    WARNING_NOT_VPC_CAN_CONNECT_OUTSIDE:
      en: "No instance in VPC has Elastic IP or auto-assigned public IP, which means this VPC can only connect to outside via VPN."
      # en: "No instance in VPC has Elastic IP, which means this VPC can only connect to outside via VPN."
      zh: "在VPC中没有实例有弹性 IP 或自动分配的公网 IP，这意味着此 VPC 只能通过 VPN 来连入。"

    # Subnet
    ERROR_CIDR_ERROR_CONNECT_TO_ELB:
      en: "Subnet <span class='validation-tag tag-subnet'>%s</span> is attached with a Load Balancer. Its mask must be smaller than /27."
      zh: "子网 <span class='validation-tag tag-subnet'>%s</span> 被附加了一个负载均衡器．它的子网掩码必须小于 /27。"

    # Instance
    NOTICE_INSTANCE_NOT_EBS_OPTIMIZED_FOR_ATTACHED_PROVISIONED_VOLUME:
      en: "Instance <span class='validation-tag tag-instance'>%s</span> has an attached Provisioned IOPS volume but is not EBS-Optimized."
      zh: "实例 <span class='validation-tag tag-instance'>%s</span> 被附加了一个预配置的 IOPS 卷，但该实例并不是 EBS优化的。"
    WARNING_INSTANCE_SG_RULE_EXCEED_FIT_NUM:
      en: "Instance <span class='validation-tag tag-instance'>%s</span> has more than %s security group rules, If a Instance has a large number of security group rules, performance can be degraded."
      zh: "实例 <span class='validation-tag tag-instance'>%s</span> 有超过 %s 条的安全组规则，如果一个实例有大量安全组规则，性能会有所下降。"
    ERROR_INSTANCE_NAT_CHECKED_SOURCE_DEST:
      en: "To allow routing to work properly, instance <span class='validation-tag tag-instance'>%s</span> should disabled Source/Destination Checking in \"Network Interface Details\""
      zh: "要允许路由工作正常，实例 <span class='validation-tag tag-instance'>%s</span> 应该在网卡设置中禁用源/目的检查。"

    ERROR_INSTANCE_REF_OLD_KEYPAIR:
      en: "%s has associated with an nonexistent key pair <span class='validation-tag'>%s</span>. Make sure to use an existing key pair or creating a new one."
      zh: "%s 分配的密钥对 <span class='validation-tag'>%s</span> 不存在，请确保使用现存的密钥对或创建一个新的密钥对。"

    NOTICE_KEYPAIR_LONE_LIVE:
      en: "Make sure you have access to all private key files associated with instances or launch configurations. Without them, you won't be able to log into your instances."
      zh: "请确保分配到实例或启动配置的私钥能够正常使用，否则您将无法登录到实例。"


    # ENI
    ERROR_ENI_NOT_ATTACH_TO_INSTANCE:
      en: "Network Interface <span class='validation-tag tag-eni'>%s</span> is not attached to any Instance."
      zh: "网络接口 <span class='validation-tag tag-eni'>%s</span> 没有被关联到任何实例上。"

    # ELB
    ERROR_VPC_HAVE_INTERNET_ELB_AND_NO_HAVE_IGW:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> is internet-facing but VPC no have an Internet Gateway."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 是 Internet-facing 的，但 VPC 中没有 Internet 网关。"

    ERROR_ELB_INTERNET_SHOULD_ATTACH_TO_PUBLIC_SB:
      en: "Internet-facing Load Balancer <span class='validation-tag tag-elb'>%s</span> should attach to a public subnet."
      zh: "Internet-facing 的负载均衡器 <span class='validation-tag tag-elb'>%s</span> 应该关联到一个公有子网上。"

    ERROR_ELB_NO_ATTACH_INSTANCE_OR_ASG:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> has no instance or auto scaling group added to it."
      zh: "没有实例或自动伸缩组被关联到负载均衡器 <span class='validation-tag tag-elb'>%s</span> 上。"

    WARNING_ELB_NO_ATTACH_TO_MULTI_AZ:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> is attached to only 1 availability zone. Attach load balancer to multiple availability zones can improve fault tolerance."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 只关联到了一个可用区域上，若关联到多个可用区域上能够提升容错性。"

    NOTICE_ELB_REDIRECT_PORT_443_TO_443:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> redirects <span class='validation-tag tag-port'>443</span> to <span class='validation-tag tag-port'>443</span>. Suggest to use load balancer to decrypt and redirect to port <span class='validation-tag tag-port'>80</span>."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 重定向 <span class='validation-tag tag-port'>443</span> 到 <span class='validation-tag tag-port'>443</span>，建议使用负载均衡解密并重定向到端口 <span class='validation-tag tag-port'>80</span>。"

    ERROR_ELB_HAVE_REPEAT_LISTENER_ITEM:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> has duplicate load balancer ports."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 的侦听端口重复。"

    ERROR_ELB_HAVE_NO_SSL_CERT:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> is using HTTPS/SSL protocol for Load Balancer Listener. Please add server certificate."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 正在使用 HTTPS/SSL 协议侦听，请添加服务器证书。"

    ERROR_ELB_RULE_NOT_INBOUND_TO_ELB_LISTENER:
      en: "Load balancer <span class='validation-tag tag-elb'>%s</span> should allow inbound traffic towards its Load Balancer Protocol: %s."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 应该允许流向侦听协议 %s 的流量。"

    WARNING_ELB_RULE_NOT_INBOUND_TO_ELB_PING_PORT:
      en: "Load balancer <span class='validation-tag tag-elb'>%s</span>'s security group rule should allow inbound traffic towards its ping port: <span class='validation-tag tag-port'>%s</span>."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 的安全组规则需要允许朝 Ping 端口 <span class='validation-tag tag-port'>%s</span> 进入的流量。"

    ERROR_ELB_RULE_NOT_OUTBOUND_TO_INSTANCE_LISTENER:
      en: "Load balancer <span class='validation-tag tag-elb'>%s</span> should allow outbound traffic towards its backend instance or auto-scaling group through Instance Protocol: %s."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 应该允许向关联的实例或自动伸缩组流向的协议 %s 的出口流量。"

    ERROR_ELB_RULE_INSTANCE_NOT_OUTBOUND_FOR_ELB_LISTENER:
      en: "%s <span class='validation-tag tag-elb'>%s</span> should allow inbound traffic towards %s according to %s's Instance Listener Protocol."
      zh: "%s <span class='validation-tag tag-elb'>%s</span> 应该依据 %s 的实例侦听协议，允许朝 %s 的进入流量。"

    ERROR_ELB_ATTACHED_SUBNET_CIDR_SUFFIX_GREATE_27:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span> has been associated with Subnet <span class='validation-tag tag-subnet'>%s</span>, whose CIDR mask must be smaller than /27."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 关联的子网 <span class='validation-tag tag-subnet'>%s</span>，其掩码必须小于 /27。"

    ERROR_ELB_SSL_CERT_NOT_EXIST_FROM_AWS:
      en: "Load Balancer <span class='validation-tag tag-elb'>%s</span>'s Listener is configured with nonexistent Server Certificate <span class='validation-tag tag-cert'>%s</span>."
      zh: "负载均衡器 <span class='validation-tag tag-elb'>%s</span> 的监听器配置的服务器证书 <span class='validation-tag tag-cert'>%s</span> 不存在。"

    # SG
    WARNING_SG_RULE_EXCEED_FIT_NUM:
      en: "Security Group <span class='validation-tag tag-sg'>%s</span> has more than %s rules, If a security group has a large number of rules, performance can be degraded."
      zh: "安全组 <span class='validation-tag tag-sg'>%s</span> 的规则超过了 %s 条，若安全组有太多规则，性能会有所下降。"
    NOTICE_STACK_USING_ONLY_ONE_SG:
      en: "This stack is only using 1 security group."
      zh: "该 Stack 只使用了一个安全组。"
    WARNING_SG_USING_ALL_PROTOCOL_RULE:
      en: "Security Group <span class='validation-tag tag-sg'>%s</span> is using 'ALL' protocol traffic."
      zh: "安全组 <span class='validation-tag tag-sg'>%s</span> 允许了 'ALL' 协议。"
    WARNING_SG_RULE_FULL_ZERO_SOURCE_TARGET_TO_OTHER_PORT:
      en: "Security Group <span class='validation-tag tag-sg'>%s</span> has inbound rule which traffic from <span class='validation-tag tag-ip'>0.0.0.0/0</span> is not targeting port <span class='validation-tag tag-port'>80</span> or <span class='validation-tag tag-port'>443</span>."
      zh: "安全组 <span class='validation-tag tag-sg'>%s</span> 有来自不是目标端口 <span class='validation-tag tag-port'>80</span> 或 <span class='validation-tag tag-port'>443</span> 的 <span class='validation-tag tag-ip'>0.0.0.0/0</span> 的入口流量规则。"
    NOTICE_SG_RULE_USING_PORT_22:
      en: "Security Group <span class='validation-tag tag-sg'>%s</span> has rule which using port <span class='validation-tag tag-port'>22</span>. To enhance security, suggest to use other port than <span class='validation-tag tag-port'>22</span>."
      zh: "安全组 <span class='validation-tag tag-sg'>%s</span> 有规则正在使用端口 <span class='validation-tag tag-port'>22</span>，要确保安全，建议使用其它端口。"
    WARNING_SG_RULE_HAVE_FULL_ZERO_OUTBOUND:
      en: "Security Group <span class='validation-tag tag-sg'>%s</span> has outbound rule towards <span class='validation-tag tag-ip'>0.0.0.0/0</span>. Suggest to change to more specific range."
      zh: "安全组 <span class='validation-tag tag-sg'>%s</span> 有朝 <span class='validation-tag tag-ip'>0.0.0.0/0</span> 的出口规则，建议更改到更明确的范围。"
    ERROR_RESOURCE_ASSOCIATED_SG_EXCEED_LIMIT:
      en: "%s <span class='validation-tag tag-%s'>%s</span>'s associated Security Group exceed max %s limit."
      zh: "%s <span class='validation-tag tag-%s'>%s</span> 分配的安全组超过最大 %s 条限制。"

    # ASG
    ERROR_ASG_HAS_NO_LAUNCH_CONFIG:
      en:"Auto Scaling Group <span class='validation-tag tag-asg'>%s</span> has no launch configuration."
      zh:"自动伸缩组 <span class='validation-tag tag-asg'>%s</span> 没有启动配置。"

    WARNING_ELB_HEALTH_NOT_CHECK:
      en: "Auto Scaling Group <span class='validation-tag tag-asg'>%s</span> has connected to Load Balancer but the Load Balancer health check is not enabled."
      zh: "自动伸缩组 <span class='validation-tag tag-asg'>%s</span> 连接到的负载均衡器的健康检查没有被启用。"

    ERROR_HAS_EIP_NOT_HAS_IGW:
      en: "VPC has instance with Elastic IP must have an Internet Gateway."
      zh: "VPC 中有分配了弹性 IP 的实例，但 VPC 没有 Internet 网关。"

    # RT
    NOTICE_RT_ROUTE_NAT:
      en: "Instance <span class='validation-tag tag-instance'>%s</span> is a target of Route Table <span class='validation-tag tag-rtb'>%s</span>. To make sure the routing works, <span class='validation-tag tag-instance'>%s</span> should have security group rule to allow traffic from subnets assciated with <span class='validation-tag tag-rtb'>%s</span>."
      zh: ""

    NOTICE_INSTANCE_HAS_RTB_NO_ELB:
      en: "Route Table <span class='validation-tag tag-rtb'>%s</span> has route to Instance <span class='validation-tag tag-instance'>%s</span>. If <span class='validation-tag tag-instance'>%s</span> is working as NAT instance, it should be assigned with an Elastic IP."
      zh: "路由表 <span class='validation-tag tag-rtb'>%s</span> 连接到了实例 <span class='validation-tag tag-instance'>%s</span>, 如果 <span class='validation-tag tag-instance'>%s</span> 正作为 NAT 实例，那么它应该被分配一个弹性 IP。"

    WARNING_NO_RTB_CONNECT_IGW:
      en: "No Route Table is connected to Internet Gateway."
      zh: "Internet 网关没有被连接到路由表。"

    WARNING_NO_RTB_CONNECT_VGW:
      en: "No Route Table is connected to VPN Gateway."
      zh: "VPN 网关没有被连接到路由表。"

    NOTICE_ACL_HAS_NO_ALLOW_RULE:
      en: "Network ACL <span class='validation-tag tag-acl'>%s</span> has no ALLOW rule. The subnet(s) associate(s) with it cannot have traffic in or out."
      zh: "网络 ACL <span class='validation-tag tag-acl'>%s</span> 没有任何允许规则，关联到的子网的流量不允许进或出。"

    ERROR_RT_HAVE_CONFLICT_DESTINATION:
      en:"Route Table <span class='validation-tag tag-rtb'>%s</span> has routes with conflicting CIDR blocks."
      zh:"路由表的路由规则中存在 CIDR 块冲突。"

    # AZ
    WARNING_SINGLE_AZ:
      en: "Only 1 Availability Zone is used. Multiple Availability Zone can improve fault tolerance."
      zh: "该 VPC 中只有一个可用区域，使用多个可用区域能够提升容错性。"

    # CGW
    ERROR_CGW_CHECKING_IP_CONFLICT:
      en:"Checking Customer Gateway IP Address confliction with existing resource..."
      zh:""
    ERROR_CGW_IP_CONFLICT:
      en:"Customer Gateway <span class='validation-tag tag-cgw'>%s</span>'s IP <span class='validation-tag tag-ip'>%s</span> conflicts with existing <span class='validation-tag tag-cgw'>%s</span>'s IP <span class='validation-tag tag-ip'>%s</span>."
      zh:""
    WARNING_CGW_IP_RANGE_ERROR:
      en:"Customer Gateway <span class='validation-tag tag-cgw'>%s</span>'s IP(%s) invalid."
      zh:""
    ERROR_CGW_MUST_ATTACH_VPN:
      en:"Customer Gateway %s must be attached to a VPN Gateway via VPN connection."
      zh:""

    # VPN
    ERROR_VPN_NO_IP_FOR_STATIC_CGW:
      en:"VPN Connection of <span class='validation-tag tag-cgw'>%s</span> and <span class='validation-tag tag-vgw'>%s</span> is missing IP prefix."
      zh:""
    ERROR_VPN_NOT_PUBLIC_IP:
      en:"VPN Connection <span class='validation-tag tag-vpn'>%s</span>'s IP prefix <span class='validation-tag tag-ip'>%s</span> is invalid."
      zh:""

    # Stack
    ERROR_STACK_CHECKING_FORMAT_VALID:
      en:"Checking Stack data format validity..."
      zh:""
    ERROR_STACK_FORMAT_VALID_FAILED:
      en:"Resource %s has format problem, %s."
      zh:""
    ERROR_STACK_HAVE_NOT_EXIST_AMI:
      en:"%s <span class='validation-tag tag-%s'>%s</span>'s AMI <span class='validation-tag tag-ami'>%s</span> is not available any more. Please change another AMI."
      zh:""
    ERROR_STACK_HAVE_NOT_EXIST_SNAPSHOT:
      en:"Snapshot <span class='validation-tag tag-snapshot'>%s</span> attached to %s <span class='validation-tag tag-instance'>%s</span> is not available or not accessible to your account. Please change another one."
      zh:""
    ERROR_STACK_HAVE_NOT_AUTHED_AMI:
      en:"You are not authorized for %s <span class='validation-tag tag-%s'>%s</span>'s AMI <span class='validation-tag tag-ami'>%s</span>. Go to AWS Marketplace to get authorized or use another AMI by creating new instance."
      zh:""

    # State Editor
    ERROR_STATE_EDITOR_INEXISTENT_INSTANCE:
      en: "Instance <span class='validation-tag tag-instance'>%s</span> <span class='validation-tag tag-state'>state %s</span> has referenced the inexistent <span class='validation-tag tag-state-ref'>%s</span>."
      zh: ""

    ERROR_STATE_EDITOR_INEXISTENT_ASG:
      en: "Auto Scaling Group <span class='validation-tag tag-asg'>%s</span> <span class='validation-tag tag-state'>state %s</span> has referenced the inexistent <span class='validation-tag tag-state-ref'>%s</span>."
      zh: ""

    ERROR_STATE_EDITOR_EMPTY_REQUIED_PARAMETER:
      en: "<span class='validation-tag tag-instance'>%s</span>'s <span class='validation-tag tag-state'>state %s</span> is missing required parameter <span class='validation-tag tag-parameter'>%s</span>."
      zh: ""

    ERROR_STATE_EDITOR_INVALID_FORMAT:
      en: "<span class='validation-tag tag-instance'>%s</span>'s <span class='validation-tag tag-state'>state %s [%s]</span> should reference a state in correct format. For example, <span class='validation-tag'>@{host1.state.3}</span>."
      zh: ""

    # State
    ERROR_NOT_CONNECT_OUT:
      en: "Subnet <span class='validation-tag tag-subnet'>%s</span> must be connected to internet directly or via a NAT instance. "
      zh: ""

    ERROR_NO_EIP_OR_PIP:
      en: "<span class='validation-tag tag-instance'>%s</span> has configured states. To make sure OpsAgent to work, <span class='validation-tag tag-instance'>%s</span> must have an elastic IP or public IP. If not, subnet <span class='validation-tag tag-subnet'>%s</span>'s outward traffic must be routed to a <a href='javascript:void(0)' class='bubble bubble-NAT-instance' data-bubble-template='bubbleNATreq'>NAT instance</a>."
      zh: ""

    ERROR_NO_CGW:
      en: "You have configured states for instance. To make sure OpsAgent to work, the VPC must have an internet gateway."
      zh: ""
    ERROR_NO_OUTBOUND_RULES:
      en: "<span class='validation-tag tag-instance'>%s</span> has configured states. To make sure OpsAgent to work, it should have outbound rules on <span class='validation-tag tag-port'>80</span> and <span class='validation-tag tag-port'>443</span> ports to the outside."
      zh: ""
    WARNING_OUTBOUND_NOT_TO_ALL:
      en: "<span class='validation-tag tag-instance'>%s</span> has configured states. Suggest to set its outbound rule on <span class='validation-tag tag-port'>80</span> and <span class='validation-tag tag-port'>443</span> to <span class='validation-tag tag-ip'>0.0.0.0/0</span>. Otherwise, agent may not be able to work properly, install packages or check out source codes lacking route to VisualOps's monitoring systems or required repositories."
      zh: ""

    # Share Resource
    ERROR_ASG_NOTIFICATION_NO_TOPIC:
      en: "Auto Scaling Group <span class='validation-tag tag-asg'>%s</span> has configured notification. Please select a SNS Topic for it."
      zh: ""

    ERROR_ASG_POLICY_NO_TOPIC:
      en: "Auto Scaling Group %s's Scaling Policy <span class='validation-tag'>%s</span> has configured notification. Please select a SNS Topic for it."
      zh: ""

    ERROR_ASG_NOTIFICITION_TOPIC_NONEXISTENT:
      en: "Auto Scaling Group <span class='validation-tag tag-asg'>%s</span> is using a nonexistent SNS Topic <span class='validation-tag'>%s</span>. Please change to an existing SNS Topic to make notification work."
      zh: ""

    ERROR_ASG_POLICY_TOPIC_NONEXISTENT:
      en: "Auto Scaling Group <span class='validation-tag tag-asg'>%s</span>'s Scaling Policy %s is using a nonexistent SNS Topic <span class='validation-tag'>%s</span>. Please change to an existing SNS Topic to make notification work."
      zh: ""

    ERROR_VPC_DHCP_NONEXISTENT:
      en: "VPC is using a nonexistent DHCP option set. Please specify default, auto-assigned or an existing DHCP option set."
      zh: ""

    WARNING_VPC_CANNOT_USE_DEFAULT_DHCP_WHEN_USE_VISUALOPS:
      en: "vpc can not use default(none) dhcpoptions when use visualops"
      zh: ""

    ERROR_RDS_DB_T1_MICRO_DEFAULT_OPTION:
      en: " DB Instance %s has db.t1.micro instance class, which can only be members of the default option group."
      zh: ""

    ERROR_RDS_CIDR_NOT_LARGE_ENOUGH:
      en: "The CIDR blocks in each of your subnets must be large enough to accommodate spare IP addresses for Amazon RDS to use during maintenance activities, including failover and compute scaling. (For each DB instance that you run in a VPC, you should reserve at least one address in each subnet in the DB subnet group for use by Amazon RDS for recovery actions.)"
      zh: ""

    ERROR_RDS_TENANCY_MUST_DEFAULT:
      en: "To launch DB instance, instance tenancy attribute of the VPC must be set to default. "
      zh: ""

    ERROR_RDS_SNAPSHOT_NOT_LARGE_ENOUGH:
      en: "Snapshot storage need large than original value."
      zh: ""

    ERROR_RDS_AZ_NOT_CONSISTENT:
      en: "DB Instance <span class='validation-tag'>%s</span> is assigned to a Preferred AZ <span class='validation-tag'>%s</span> inconsistent with its subnet group."
      zh: ""

    ERROR_RDS_ACCESSIBLE_NOT_HAVE_IGW:
      en: "To allow DB instance to be publicly accessible, VPC must have an Internet Gateway."
      zh: ""

    ERROR_RDS_ACCESSIBLE_NOT_HAVE_DNS:
      en: "To allow DB instance to be publicly accessible, VPC must enable DNS hostnames and DNS resolution."
      zh: ""

    ERROR_RDS_OG_COMPATIBILITY:
      en: "App Update: Option Group compatibility."
      zh: ""

    WARNING_RDS_UNUSED_OG_NOT_CREATE:
      en: "Unused Option Group %s will not be created in live app."
      zh: ""

    ERROR_RDS_OG_EXCEED_20_LIMIT:
      en: "Region %s has reached the limit of 20 option groups."
      zh: ""

    ERROR_RDS_SQL_SERVER_MIRROR_MUST_HAVE3SUBNET:
      en: "DB Instance <span class='validation-tag tag-rds'>%s</span> is using SQL Server Mirroring (Multi-AZ). Its subnet group must have 3 subnets in distinct Availability Zones."
      zh: ""

    ERROR_RDS_BACKUP_MAINTENANCE_OVERLAP:
      en: "DB Instance <span class='validation-tag tag-rds'>%s</span> Backup Window and Maintenance Window are overlapping. Please update to avoid overlapping."
      zh: ""

    ERROR_HAVE_NOT_ENOUGH_IP_FOR_DB:
      en:"To accommodate spare IP address for Amazon RDS to use during maintenance activities, subnet <span class='validation-tag tag-subnet'>%s</span> should use a larger CIDR block."
      zh: ""

    ERROR_REPLICA_STORAGE_SMALL_THAN_ORIGIN:
      en: "Read Replica <span class='validation-tag tag-rds'>%s</span> should have same or larger storage than its source <span class='validation-tag tag-rds'>%s</span>."
      zh: ""

    ERROR_MASTER_PASSWORD_INVALID:
      en: "DB instance <span class='validation-tag tag-rds'>%s</span>'s Master Password must contain 8 to 41 characters."
      zh: ""

    ERROR_OG_DB_BOTH_MODIFIED:
      en: "DB Instance %s cannot be modified in the same update with the Option Group %s it is using."
      zh: ""


    ##### Trust Advisor