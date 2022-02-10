output "access_key" {
  description = "The  AWS-compatible s3-storage's access key"

  value = yandex_iam_service_account_static_access_key.bucket-uploader-key.access_key
}

output "secret_key" {
  description = "The  AWS-compatible s3-storage's secret key"

  value     = yandex_iam_service_account_static_access_key.bucket-uploader-key.secret_key
  sensitive = true
}

output "bucket_name" {
  description = "The  AWS-compatible s3-storage's bucket name"

  value = yandex_storage_bucket.bucket.bucket
}

output "endpoint" {
  description = "The  AWS-compatible s3-storage bucket's web-endpoint"

  value = "storage.yandexcloud.net"
}

output "region" {
  description = "The  AWS-compatible s3-storage bucket's region"

  value = "ru-central1-a"
}
