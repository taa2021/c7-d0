# ipv4eaddr

## Примечания к реализации

Ожидаемый эффект - как можно более простой переход на иную облачную платформу.

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
| [yandex_vpc_address.addr](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| region | Cloud zone/region for the deployable host | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| address | The cloud external Internet IPv4-address |
| id | The cloud ID for external Internet IPv4-address |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
