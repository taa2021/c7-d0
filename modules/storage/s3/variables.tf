variable "bucket-name" {
  description = "The  AWS-compatible s3-storage's bucket name"

  type = string
}

variable "bucket-is-versioning" {
  description = "Predicate: is versioning enabled for the s3-storage bucket"

  type    = bool
  default = true
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = {}
}
