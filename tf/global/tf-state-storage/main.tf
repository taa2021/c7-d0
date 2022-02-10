terraform {
  required_version = "= 1.1.3"

  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "random_id" "bucket" {
  byte_length = 8
}

provider "yandex" {
  token    = var.yc_iam_token
  cloud_id = var.yc_cloud_id
}

# The s3-compartable versioning storage for terraform states
module "s3-backend" {
  source      = "../../modules/storage/s3"
  cloud-tags  = var.cloud-tags
  bucket-name = var.bucket-name != "" ? var.bucket-name : format("%s-%s", "bucket-", random_id.bucket.hex)
}
