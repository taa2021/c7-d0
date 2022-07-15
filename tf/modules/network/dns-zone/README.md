# dns-zone

## Примечания к реализации

DNS-зона


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
| [yandex_dns_zone.zone](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/dns_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |
| is-public | Is the zone public? | `bool` | `false` | no |
| name | The cloud dns zone's name | `string` | n/a | yes |
| vpc-id | The VPC's id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud dns zone's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
