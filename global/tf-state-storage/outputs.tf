output "access-key" {
  description = "The  AWS-compatible s3-storage's access key"

  value = module.s3-backend.access-key
}

output "secret-key" {
  description = "The  AWS-compatible s3-storage's secret key"

  value     = module.s3-backend.secret-key
  sensitive = true
}

output "bucket-name" {
  description = "The  AWS-compatible s3-storage's bucket name"

  value = module.s3-backend.bucket
}

output "bucket-endpoint" {
  description = "The  AWS-compatible s3-storage bucket's web-endpoint"

  value = module.s3-backend.endpoint
}

output "bucket-region" {
  description = "The  AWS-compatible s3-storage bucket's region"

  value = module.s3-backend.region
}
