data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}@*/${var.github_repo}@*:ref:refs/heads/*",
        "repo:${var.github_org}@*/${var.github_repo}@*:environment:*",
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.project_name}-github-actions"
  description        = "Assumed by GitHub Actions via OIDC to run Terraform"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "foundation" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_foundation.arn
}

resource "aws_iam_role_policy_attachment" "infrastructure" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_infrastructure.arn
}

resource "aws_iam_role_policy_attachment" "state" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_state.arn
}
