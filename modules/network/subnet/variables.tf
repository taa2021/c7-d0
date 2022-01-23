variable "region" {
  description = "Cloud zone/region for the deployable network resources"

  type = string
}

variable "vpc-id" {
  description = "The cloud network's ID"

  type = string
}

variable "cidr" {
  description = "CIDR for the deployable network resources"

  type = string
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
