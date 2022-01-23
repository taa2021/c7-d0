variable "region" {
  description = "Cloud zone/region for the deployable host"

  type = string
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
