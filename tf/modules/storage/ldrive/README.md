# ldrive

## Примечания к реализации

(Дополнительный) диск


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| yandex | ~>0.70.0 |

## Providers

| Name | Version |
|------|---------|
| yandex | 0.70.0 |

## Resources

| Name | Type |
|------|------|
| [yandex_compute_disk.result](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_disk) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| size | The drive's size | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud drive's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
