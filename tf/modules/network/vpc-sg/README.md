# vg-sg

## Примечания к реализации

Создали - отдали.
Группы безопасности позволяют управлять доступом ВМ к ресурсам и группам безопасности
облака или ресурсам в интернете. Группа безопасности назначается сетевому интерфейсу
при создании или изменении ВМ и должна содержать правила для получения и отправки трафика.
Каждой ВМ можно назначить несколько групп безопасности.
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
| [yandex_vpc_security_group.vpc-sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| rules | The cloud network's ID | ```list( object({ predef_tgt = string # null | self direction = string # ingress | egress v4_cidrs = set(string) proto = string from_port = number to_port = number }))``` | ```[ { "direction": "ingress", "from_port": -1, "predef_tgt": "self", "proto": "ANY", "to_port": -1, "v4_cidrs": [] }, { "direction": "egress", "from_port": -1, "predef_tgt": "self", "proto": "ANY", "to_port": -1, "v4_cidrs": [] }, { "direction": "egress", "from_port": -1, "predef_tgt": "cidr", "proto": "ANY", "to_port": -1, "v4_cidrs": [ "0.0.0.0/0" ] }, { "direction": "ingress", "from_port": -1, "predef_tgt": "cidr", "proto": "ICMP", "to_port": -1, "v4_cidrs": [ "0.0.0.0/0" ] }, { "direction": "ingress", "from_port": 22, "predef_tgt": "cidr", "proto": "TCP", "to_port": 22, "v4_cidrs": [ "0.0.0.0/0" ] }, { "direction": "ingress", "from_port": 51820, "predef_tgt": "cidr", "proto": "UDP", "to_port": 51820, "v4_cidrs": [ "0.0.0.0/0" ] } ]``` | no |
| vpc-id | The cloud network's ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud security group's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
