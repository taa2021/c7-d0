terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "~>0.70.0" }
  }
}

resource "yandex_resourcemanager_folder" "s3-folder" {
  name   = "s3-folder-of-bucket-${var.bucket-name}"
  labels = var.cloud-tags
}

resource "yandex_iam_service_account" "bucket-acc-admin" {
  name      = "s3-acc-admin-of-bucket-${var.bucket-name}"
  folder_id = yandex_resourcemanager_folder.s3-folder.id
}

resource "yandex_resourcemanager_folder_iam_member" "acc-bucket-admin-acl" {
  folder_id = yandex_resourcemanager_folder.s3-folder.id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-acc-admin.id}"
}

resource "yandex_iam_service_account_static_access_key" "bucket-admin-key" {
  service_account_id = yandex_iam_service_account.bucket-acc-admin.id
}

resource "yandex_iam_service_account" "bucket-acc-uploader" {
  name      = "s3-acc-uploader-of-bucket-${var.bucket-name}"
  folder_id = yandex_resourcemanager_folder.s3-folder.id
}

resource "yandex_resourcemanager_folder_iam_member" "acc-bucket-uploader-acl" {
  folder_id = yandex_resourcemanager_folder.s3-folder.id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-acc-uploader.id}"
}

resource "yandex_iam_service_account_static_access_key" "bucket-uploader-key" {
  service_account_id = yandex_iam_service_account.bucket-acc-uploader.id
}

resource "yandex_kms_symmetric_key" "bucket-skey" {
  folder_id         = yandex_resourcemanager_folder.s3-folder.id
  name              = "s3-bucket-skey-${var.bucket-name}"
  default_algorithm = "AES_256"
  rotation_period   = "24h"
  labels            = var.cloud-tags
}

resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.bucket-admin-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-admin-key.secret_key
  bucket     = var.bucket-name

  versioning {
    enabled = var.bucket-is-versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket-skey.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
