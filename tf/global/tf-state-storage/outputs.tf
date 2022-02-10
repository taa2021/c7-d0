output "access_key" {
  description = "The  AWS-compatible s3-storage's access key"

  value = module.s3-backend.access_key
}

output "secret_key" {
  description = "The  AWS-compatible s3-storage's secret key"

  value     = module.s3-backend.secret_key
  sensitive = true
}

output "bucket_name" {
  description = "The  AWS-compatible s3-storage's bucket name"

  value = module.s3-backend.bucket_name
}

output "bucket_endpoint" {
  description = "The  AWS-compatible s3-storage bucket's web-endpoint"

  value = module.s3-backend.endpoint
}

output "bucket_region" {
  description = "The  AWS-compatible s3-storage bucket's region"

  value = module.s3-backend.region
}
