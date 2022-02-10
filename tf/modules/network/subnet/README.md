# subnet

## Примечания к реализации

Создали - отдали; CIDR не должны пересекаться в рамках облачной сети (vpc-id);
маинимальная, максимальная длины масок - облачно-провайдеро-зависимые.
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
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr | CIDR for the deployable network resources | `string` | n/a | yes |
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| region | Cloud zone/region for the deployable network resources | `string` | n/a | yes |
| vpc-id | The cloud network's ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud subnetwork's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
