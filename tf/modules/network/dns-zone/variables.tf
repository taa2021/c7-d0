
variable "name" {
  description = "The cloud dns zone's name"

  type = string
}

variable "is-public" {
  description = "Is the zone public?"

  type    = bool
  default = false
}

variable "vpc-id" {
  description = "The VPC's id"

  type = string
}


variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
