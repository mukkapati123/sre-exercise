locals {
  ansible_dir = "${path.module}/../../ansible.d"

  ansible_content_hash = sha256(join("", [
    for f in sort(tolist(fileset(local.ansible_dir, "**"))) :
    filesha256("${local.ansible_dir}/${f}")
  ]))

  user_data_common = templatefile("${path.module}/user_data_common.sh.tftpl", {
    auth_log_group = aws_cloudwatch_log_group.auth.name
  })

  user_data_web = templatefile("${path.module}/user_data_web.sh.tftpl", {
    common       = local.user_data_common
    repo_url     = var.ansible_repo_url
    repo_branch  = var.ansible_repo_branch
    content_hash = local.ansible_content_hash
  })
}
