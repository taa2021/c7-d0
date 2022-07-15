
variable "vpc-id" {
  description = "The cloud network's ID"

  type = string
}


variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
