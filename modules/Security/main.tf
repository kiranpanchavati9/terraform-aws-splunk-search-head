resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge({ Name = var.security_group_name }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = {
    for pair in setproduct(var.ingress_ports, var.ingress_cidrs) :
    "${pair[0]}-${pair[1]}" => { port = pair[0], cidr = pair[1] }
  }

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  tags              = { Name = "${var.security_group_name}-${each.value.port}" }
}

resource "aws_vpc_security_group_ingress_rule" "from_sg" {
  for_each = toset([for p in var.ingress_ports_from_sg : tostring(p)])

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.source_security_group_id
  from_port                    = tonumber(each.value)
  to_port                      = tonumber(each.value)
  ip_protocol                  = "tcp"
  tags                         = { Name = "${var.security_group_name}-from-sg-${each.value}" }
}

resource "aws_vpc_security_group_ingress_rule" "self" {
  for_each = toset([for p in var.ingress_ports_self : tostring(p)])

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = aws_security_group.this.id
  from_port                    = tonumber(each.value)
  to_port                      = tonumber(each.value)
  ip_protocol                  = "tcp"
  tags                         = { Name = "${var.security_group_name}-self-${each.value}" }
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags              = { Name = "${var.security_group_name}-egress" }
}