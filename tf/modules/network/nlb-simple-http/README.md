# nlb-simple-http

## Примечания к реализации

Создаем backend-группу, используем её при создании балансировщика.
Платформенно-облачно-зависимые параметры для создания группы забираем из хостов
(чьи идентификаторы получили на входе).
Платформенно-облачно-зависимые обязательные имена секций балансировщика -
не имеют практического значения, генерируем на лету.
Ожидаемый эффект - как можно более простой переход на иную облачную платформу.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| yandex | ~>0.70.0 |

## Providers

| Name | Version |
|------|---------|
| random | 3.3.2 |
| yandex | 0.70.0 |

## Resources

| Name | Type |
|------|------|
| [random_id.rname](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [yandex_lb_network_load_balancer.nlb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer) | resource |
| [yandex_lb_target_group.nlb-tg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group) | resource |
| [yandex_compute_instance.hosts0](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_instance) | data source |
| [yandex_compute_instance.hosts1](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_instance) | data source |
| [yandex_compute_instance.hosts2](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| healthcheck-path | The deployable network load balancer backend hosts' (http) health check path | `string` | `"/"` | no |
| hosts0-ids | The deployable network load balancer backend hosts' cloud IDs | `list(string)` | n/a | yes |
| hosts1-ids | The deployable network load balancer backend hosts' cloud IDs (optional) | `list(string)` | `[]` | no |
| hosts2-ids | The deployable network load balancer backend hosts' cloud IDs (optional) | `list(string)` | `[]` | no |
| port-inner | The deployable network load balancer's backends' inner TCP port (same for all backends) | `number` | `80` | no |
| port-outer | The deployable network load balancer's external Internet TCP-port | `number` | `80` | no |

## Outputs

| Name | Description |
|------|-------------|
| addr-ext | The deployed network load balancer's external IPv4 address |
| id | The deployed network load balancer's cloud ID |
| port-inner | The deployed network load balancer's backends' inner TCP port (same for all backends) |
| port-outer | The deployed network load balancer's external Internet TCP-port |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
