# vpnc-sg-self

## Примечания к реализации

Создали - отдали (внутри группы безопасности - неограниченный достп).
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc-sg-self | ../vpc-sg | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| vpc-id | The cloud network's ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud security group's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
