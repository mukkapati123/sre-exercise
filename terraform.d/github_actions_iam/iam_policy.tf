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

data "aws_iam_policy_document" "terraform_infrastructure" {
  statement {
    sid    = "ComputeManagement"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyInstanceMetadataOptions",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:volume/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:key-pair/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:launch-template/*",
      "arn:aws:ec2:${var.aws_region}::image/*",
    ]
  }

  statement {
    sid    = "LaunchTemplateManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:DeleteLaunchTemplateVersions",
      "ec2:ModifyLaunchTemplate",
    ]
    resources = ["arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:launch-template/*"]
  }

  statement {
    sid    = "SecurityGroupManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ModifySecurityGroupRules",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group-rule/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*",
    ]
  }

  statement {
    sid    = "ComputeTagging"
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:volume/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group-rule/*",
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:launch-template/*",
    ]
  }

  statement {
    sid    = "InstanceRoleManagement"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:ListRoleTags",
      "iam:ListInstanceProfileTags",
    ]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-*",
      "arn:aws:iam::${var.aws_account_id}:instance-profile/${var.project_name}-*",
    ]
  }

  statement {
    sid       = "PassInstanceRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid       = "ServiceLinkedRoles"
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::${var.aws_account_id}:role/aws-service-role/*"]
  }

  statement {
    sid    = "LoadBalancerManagement"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]
    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:loadbalancer/app/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:targetgroup/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:listener/app/*",
    ]
  }

  statement {
    sid    = "AutoScalingManagement"
    effect = "Allow"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:DetachLoadBalancerTargetGroups",
      "autoscaling:PutScalingPolicy",
      "autoscaling:DeletePolicy",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteTags",
    ]
    resources = ["arn:aws:autoscaling:${var.aws_region}:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/${var.project_name}-*"]
  }

  statement {
    sid    = "CloudWatchManagement"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
    ]
    resources = ["arn:aws:cloudwatch:${var.aws_region}:${var.aws_account_id}:alarm:${var.project_name}-*"]
  }

  statement {
    sid    = "LogGroupManagement"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",
      "logs:ListTagsLogGroup",
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/${var.project_name}/*"]
  }

  statement {
    sid    = "SnsManagement"
    effect = "Allow"
    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:TagResource",
      "sns:UntagResource",
      "sns:ListTagsForResource",
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

  statement {
    sid    = "ReadOnlyLookups"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:GetSecurityGroupsForVpc",
      "elasticloadbalancing:Describe*",
      "autoscaling:Describe*",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:DescribeLogGroups",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptionsByTopic",
      "sns:GetSubscriptionAttributes",
      "iam:ListRoles",
      "iam:ListPolicies",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_infrastructure" {
  name        = "${var.project_name}-terraform-infrastructure"
  description = "Compute and application permissions for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.terraform_infrastructure.json
  tags        = local.common_tags
}

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
}

resource "aws_iam_policy" "terraform_state" {
  name        = "${var.project_name}-terraform-state"
  description = "Remote state permissions for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.terraform_state.json
  tags        = local.common_tags
}
