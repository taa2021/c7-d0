variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
