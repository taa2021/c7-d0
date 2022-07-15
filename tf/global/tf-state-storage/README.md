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

## Providers

| Name | Version |
|------|---------|
| random | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| s3-backend | ../../modules/storage/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket-name | The s3-storage bucket name | `string` | `""` | no |
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "terraform": true }``` | no |
| is-bucket-versioning | Predicate: is versioning enabled for the s3-storage bucket | `bool` | `true` | no |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | n/a | yes |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | n/a | yes |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_key | The  AWS-compatible s3-storage's access key |
| bucket\_endpoint | The  AWS-compatible s3-storage bucket's web-endpoint |
| bucket\_name | The  AWS-compatible s3-storage's bucket name |
| bucket\_region | The  AWS-compatible s3-storage bucket's region |
| secret\_key | The  AWS-compatible s3-storage's secret key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
