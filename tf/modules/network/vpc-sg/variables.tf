
variable "vpc-id" {
  description = "The cloud network's ID"

  type = string
}


variable "rules" {
  description = "The cloud network's ID"

  type = list(
    object({
      predef_tgt = string # null | self
      direction  = string # ingress | egress
      v4_cidrs   = set(string)
      proto      = string
      from_port  = number
      to_port    = number
  }))


  default = [
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
    {
      predef_tgt = "cidr"
      direction  = "egress"
      v4_cidrs   = ["0.0.0.0/0", ]
      proto      = "ANY"
      from_port  = -1
      to_port    = -1
    },
    {
      predef_tgt = "cidr"
      direction  = "ingress"
      v4_cidrs   = ["0.0.0.0/0"]
      proto      = "ICMP"
      from_port  = -1
      to_port    = -1
    },
    {
      predef_tgt = "cidr"
      direction  = "ingress"
      v4_cidrs   = ["0.0.0.0/0"]
      proto      = "TCP"
      from_port  = 22 # ssh
      to_port    = 22 # ssh
    },
    {
      predef_tgt = "cidr"
      direction  = "ingress"
      v4_cidrs   = ["0.0.0.0/0"]
      proto      = "UDP"
      from_port  = 51820 # wireguard
      to_port    = 51820 # wireguard
    },
  ]
}


variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
