data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)
  id       = each.value
}

data "aws_subnet" "private" {
  for_each = toset(var.private_subnet_ids)
  id       = each.value
}

locals {
  alb_azs = [for s in data.aws_subnet.public : s.availability_zone]

  web_subnet_ids = [
    for id, s in data.aws_subnet.private : id
    if contains(local.alb_azs, s.availability_zone)
  ]
}
