# host

## Примечания к реализации

Создаем экземпляр вычислителя
с использованием последнего (самого нового) образа (шаблона хоста) семейства.
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
| [yandex_compute_instance.host](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_compute_image.image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| cpu-fraq | The reserved share of processor (%) for the deployable host | `number` | `5` | no |
| has-eaddr | Predicate: is needed external Internet IP-address for the deployable host? | `bool` | `false` | no |
| image-family | Cloud image family for the deployable host | `string` | n/a | yes |
| is-preemptible | Predicate: is cheaper setup config with sudden shutdown for the deployable host? | `bool` | `true` | no |
| login | The (ssh) user login-name for the deployable host's default user account | `string` | `"user"` | no |
| mem | RAM size (GiB) for the deployable host | `number` | `1` | no |
| ncpu | Amount of CPU's for the deployable host | `number` | `2` | no |
| platform | Cloud platform for the deployable host | `string` | `"standard-v1"` | no |
| region | Cloud zone/region for the deployable host | `string` | n/a | yes |
| ssh | The ssh public key for the deployable host's default user account | `string` | n/a | yes |
| subnet | Cloud subnet's ID for the deployable host | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addr-ext | The yandex.cloud deployed host's external Internet IP-address |
| addr-int | The yandex.cloud deployed host's internal Intranet IP-address |
| id | The yandex.cloud deployed host's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
