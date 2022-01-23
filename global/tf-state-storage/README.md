# tf-state-storage

## Примечания к реализации

Это _совместимое_ s3-хранилище: версионирование - поддерживается, блокировка - нет;
необходимо это учитывать при развертывании.
Ожидаемый эффект - как можно более простой переход на иную облачную платформу.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | = 1.1.3 |
| yandex | ~>0.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| s3-backend | ../../modules/storage/s3 | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket-name | The s3-storage bucket name | `string` | `"tf--c2-br-7--2"` | no |
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "environment": "dev", "terraform": true }``` | no |
| is-bucket-versioning | Predicate: is versioning enabled for the s3-storage bucket | `bool` | `true` | no |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | `"b1gjilr27b0mqp90rj46"` | no |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | `"b1gjo8k8qajfr6ftho2n"` | no |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| access-key | The  AWS-compatible s3-storage's access key |
| bucket-endpoint | The  AWS-compatible s3-storage bucket's web-endpoint |
| bucket-name | The  AWS-compatible s3-storage's bucket name |
| bucket-region | The  AWS-compatible s3-storage bucket's region |
| secret-key | The  AWS-compatible s3-storage's secret key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
