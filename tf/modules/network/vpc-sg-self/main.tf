terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}


locals {
  rules = [
    {
      predef_tgt = "self"
      direction  = "ingress"
      v4_cidrs   = []
      proto      = "ANY"
      from_port  = -1
      to_port    = -1
    },
    {
      predef_tgt = "self"
      direction  = "egress"
      v4_cidrs   = []
      proto      = "ANY"
      from_port  = -1
      to_port    = -1
    },
  ]

}

#  The secure group for the deployable hosts
module "vpc-sg-self" {
  source = "../vpc-sg"

  rules      = local.rules
  vpc-id     = var.vpc-id
  cloud-tags = var.cloud-tags
}

