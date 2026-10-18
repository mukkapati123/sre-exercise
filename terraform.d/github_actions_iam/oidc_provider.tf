# No thumbprint_list: AWS stopped relying on the caller-supplied thumbprint for
# token.actions.githubusercontent.com in mid-2023 and validates the endpoint
# against its own trust store, so pinning one here only creates a value that
# silently rots when GitHub rotates its certificate.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-github-oidc"
    }
  )
}
