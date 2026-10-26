resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb"
  description = "Public entry point for HTTP traffic"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.project_name}-alb" }
}

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion"
  description = "Jump host, SSH from a single operator address"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.project_name}-bastion" }
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web"
  description = "Web tier, reachable only from the load balancer and the bastion"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.project_name}-web" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Forward to the web tier"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  description       = "SSH from the operator address only"
  cidr_ipv4         = var.admin_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_to_web_ssh" {
  security_group_id            = aws_security_group.bastion.id
  description                  = "SSH on to the web tier"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_to_web_http" {
  security_group_id            = aws_security_group.bastion.id
  description                  = "HTTP to the web tier for manual checks"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "bastion_https" {
  security_group_id = aws_security_group.bastion.id
  description       = "HTTPS out for SSM and package updates"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "web_http_from_alb" {
  security_group_id            = aws_security_group.web.id
  description                  = "HTTP from the load balancer"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "web_http_from_bastion" {
  security_group_id            = aws_security_group.web.id
  description                  = "HTTP from the bastion for manual checks"
  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh_from_bastion" {
  security_group_id            = aws_security_group.web.id
  description                  = "SSH from the bastion only"
  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "web_all" {
  security_group_id = aws_security_group.web.id
  description       = "Outbound via NAT"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
