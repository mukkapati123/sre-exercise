# Permissions for the foundation module: VPC, subnets, gateways, routing.
data "aws_iam_policy_document" "terraform_foundation" {
  statement {
    sid    = "VpcManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:AssociateVpcCidrBlock",
      "ec2:DisassociateVpcCidrBlock",
    ]
    resources = ["arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*"]
  }

  statement {
    sid    = "SubnetManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:ModifySubnetAttribute",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
    ]
  }

  statement {
    sid    = "InternetGatewayManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
    ]
  }

  # CreateNatGateway is authorised against the gateway, the subnet it lands in
  # and the EIP it consumes, so all three have to be listed here.
  statement {
    sid    = "NatGatewayManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:natgateway/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:elastic-ip/*",
    ]
  }

  # AllocateAddress cannot be scoped to an ARN: the address does not exist when
  # the call is authorised, so the service authorization reference lists no
  # resource type for it and it has to be granted on "*".
  statement {
    sid       = "ElasticIpAllocation"
    effect    = "Allow"
    actions   = ["ec2:AllocateAddress"]
    resources = ["*"]
  }

  statement {
    sid       = "ElasticIpManagement"
    effect    = "Allow"
    actions   = ["ec2:ReleaseAddress"]
    resources = ["arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:elastic-ip/*"]
  }

  statement {
    sid    = "RouteTableManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:ReplaceRoute",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
    ]
  }

  statement {
    sid    = "RouteTableAssociations"
    effect = "Allow"
    actions = [
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*",
    ]
  }

  # Tagging is a separate authorisation check from the create call itself, and it
  # is evaluated against the resource being tagged. Every type the foundation
  # creates has to be listed or tag-on-create fails with UnauthorizedOperation.
  statement {
    sid    = "ResourceTagging"
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:natgateway/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:elastic-ip/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:route-table/*",
    ]
  }

  # EC2 Describe calls do not support resource-level permissions; scoping them to
  # an ARN grants nothing, so they have to sit in their own "*" statement.
  statement {
    sid       = "DescribeNetworkResources"
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_foundation" {
  name        = "${var.project_name}-terraform-foundation"
  description = "Foundation networking permissions for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.terraform_foundation.json
  tags        = local.common_tags
}

# Permissions for the compute layer. Covers resources not yet in this repo
# (ALB, ASG, alarms, secrets) so the role does not need editing per module.
data "aws_iam_policy_document" "terraform_infrastructure" {
  statement {
    sid    = "EC2Management"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:ModifyInstanceAttribute",
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:volume/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
    ]
  }

  statement {
    sid       = "ImageLookup"
    effect    = "Allow"
    actions   = ["ec2:DescribeImages", "ec2:DescribeImageAttribute"]
    resources = ["*"]
  }

  statement {
    sid    = "SecurityGroupManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ModifySecurityGroupRules",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
    ]
  }

  statement {
    sid    = "IAMRoleManagement"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
    ]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-*",
      "arn:aws:iam::${var.aws_account_id}:instance-profile/${var.project_name}-*",
    ]
  }

  statement {
    sid    = "LoadBalancerManagement"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
    ]
    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:loadbalancer/app/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:targetgroup/*",
    ]
  }

  statement {
    sid    = "AutoScalingManagement"
    effect = "Allow"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DescribeLaunchConfigurations",
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
    ]
    resources = [
      "arn:aws:autoscaling:${var.aws_region}:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:launch-template/*",
    ]
  }

  statement {
    sid    = "CloudWatchManagement"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
    ]
    resources = ["arn:aws:cloudwatch:${var.aws_region}:${var.aws_account_id}:alarm:*"]
  }

  statement {
    sid    = "SNSManagement"
    effect = "Allow"
    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe",
    ]
    resources = ["arn:aws:sns:${var.aws_region}:${var.aws_account_id}:${var.project_name}-*"]
  }

  statement {
    sid    = "SecretsAccess"
    effect = "Allow"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:PutSecretValue",
    ]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.project_name}-*"]
  }
}

resource "aws_iam_policy" "terraform_infrastructure" {
  name        = "${var.project_name}-terraform-infrastructure"
  description = "Compute and application permissions for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.terraform_infrastructure.json
  tags        = local.common_tags
}

# Permissions for the S3 backend and its DynamoDB lock table.
data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid    = "S3StateAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.state_bucket}",
      "arn:aws:s3:::${var.state_bucket}/*",
    ]
  }

  statement {
    sid    = "DynamoDBLocking"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = ["arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.state_lock_table}"]
  }
}

resource "aws_iam_policy" "terraform_state" {
  name        = "${var.project_name}-terraform-state"
  description = "Remote state and locking permissions for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.terraform_state.json
  tags        = local.common_tags
}
