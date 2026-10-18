# The sub condition is the only thing standing between this role and any repo on
# GitHub, so it is pinned to a single branch of a single repo. Widen it to
# "repo:org/repo:*" only if pull request workflows need to assume the role too.
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
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"]
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
