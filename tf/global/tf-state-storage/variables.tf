variable "yc_iam_token" {
  description = "Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file"

  type      = string
  sensitive = true
}

variable "yc_cloud_id" {
  description = "Yandex.Cloud ID default"

  type = string
}

variable "yc_folder_id" {
  description = "Yandex.Cloud Folder ID default"

  type = string
}

variable "yc_zone" {
  description = "Yandex.Cloud zone default"

  type    = string
  default = "ru-central1-a"
}

variable "bucket-name" {
  description = "The s3-storage bucket name"

  type    = string
  default = ""
}

variable "is-bucket-versioning" {
  description = "Predicate: is versioning enabled for the s3-storage bucket"

  type    = bool
  default = true
}

variable "cloud-tags" {
  description = "The Terraform object's cloud tags/labels"

  type    = map(any)
  default = { terraform = true, environment = "dev" }
}
