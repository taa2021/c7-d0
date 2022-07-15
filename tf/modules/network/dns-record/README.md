# dns-zone

## Примечания к реализации

DNS-запись


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
| [yandex_dns_recordset.rs](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/dns_recordset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| data | The string data for the records in this record set. | `set(string)` | n/a | yes |
| name | The DNS name this record set will apply to. | `string` | n/a | yes |
| type | The DNS record set type. | `string` | n/a | yes |
| zone-id | The cloud dns zone's ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The cloud dns record's ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
