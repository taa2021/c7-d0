terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_vpc_security_group" "vpc-sg" {
  network_id = var.vpc-id

  # ingress self
  dynamic "ingress" {
    for_each = [for n in compact([for i in range(length(var.rules)) : (var.rules[i].direction == "ingress" && var.rules[i].predef_tgt == "self") ? tostring(i) : ""]) : tonumber(n)]
    content {
      predefined_target = "self_security_group"
      protocol          = var.rules[ingress.value].proto
      from_port         = var.rules[ingress.value].from_port
      to_port           = var.rules[ingress.value].to_port
    }
  }

  # egress self
  dynamic "egress" {
    for_each = [for n in compact([for i in range(length(var.rules)) : (var.rules[i].direction == "egress" && var.rules[i].predef_tgt == "self") ? tostring(i) : ""]) : tonumber(n)]
    content {
      predefined_target = "self_security_group"
      protocol          = var.rules[egress.value].proto
      from_port         = var.rules[egress.value].from_port
      to_port           = var.rules[egress.value].to_port
    }
  }

  # ingress non-self
  dynamic "ingress" {
    for_each = [for n in compact([for i in range(length(var.rules)) : (var.rules[i].direction == "ingress" && var.rules[i].predef_tgt == "cidr") ? tostring(i) : ""]) : tonumber(n)]
    content {
      protocol       = var.rules[ingress.value].proto
      v4_cidr_blocks = var.rules[ingress.value].v4_cidrs
      from_port      = var.rules[ingress.value].from_port
      to_port        = var.rules[ingress.value].to_port
    }
  }

  # egress non-self
  dynamic "egress" {
    for_each = [for n in compact([for i in range(length(var.rules)) : (var.rules[i].direction == "egress" && var.rules[i].predef_tgt == "cidr") ? tostring(i) : ""]) : tonumber(n)]
    content {
      protocol       = var.rules[egress.value].proto
      v4_cidr_blocks = var.rules[egress.value].v4_cidrs
      from_port      = var.rules[egress.value].from_port
      to_port        = var.rules[egress.value].to_port
    }
  }

  labels = var.cloud-tags
}

