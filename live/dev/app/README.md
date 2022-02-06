# app

## Примечания к реализации

Используемый для хранения состояний бекенд terraform - aws-совместимый,
поддерживает версионирование, но не поддерживает блокировку,- необходимо учесть при работе,
необходимо учесть при внешнем контроле соблюдения лючших практик развернутой инфраструктуры;
параметры корзины бекенда - копируем ..оттуда-то... (ссылка на общекорпоративное хранилище "секретов");
инициализация корзины бекенда производится ...теми-то... на основе модуля в подкаталоге global
(при необходимости вывода секрето-чувствительных параметров - например, использовать команду:
```
terraform output -json"
```
);
упоминание ключей доступа, авторизации S3 напрямую в tf-файлах или иных отслеживаемых системой управления
версий файлах инфраструктуры - строго запрещено,
необходимо использовать переменные среды окружения (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) 
или более безопасные механизмы.

Необходимый для авторизации облачного провайдера в облачной инфраструктуре IAM-yandex-токен -
секрето-чувствительный параметр,его упоминание напрямую в tf--файлах или иных отслеживаемых системой управления
версий файлах инфраструктуры - строго запрещено,
необходимо использовать переменные среды окружения (TF_VAR_yc_iam_token)
или более безопасные механизмы.

Согласно заданию использование статически выделенных зарезирвированных внешних ip-адресов - не требуется.



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | = 1.1.3 |
| yandex | ~>0.70.0 |

## Providers

| Name | Version |
|------|---------|
| local | 2.1.0 |
| null | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| hosts | ../../../modules/compute/host | n/a |
| vpc-network | ../../../modules/network/vpc | n/a |
| vpc-subnet | ../../../modules/network/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.ansible-configs](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.etc-configs](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.provision](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "environment": "dev", "terraform": true }``` | no |
| hosts | The setting templates for the cloud hosts | ```list( object({ image-family = string has-eaddr = bool login = string ssh = string }))``` | ```[ { "has-eaddr": true, "image-family": "ubuntu-2004-lts", "login": "ruser0", "ssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28 = " }, { "has-eaddr": false, "image-family": "ubuntu-2004-lts", "login": "ruser0", "ssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28 = " }, { "has-eaddr": false, "image-family": "centos-stream-8", "login": "ruser0", "ssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28 = " } ]``` | no |
| subnet | Yandex.Cloud zone default | `string` | `"192.168.1.0/28"` | no |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | `"b1gjilr27b0mqp90rj46"` | no |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | `"b1gjo8k8qajfr6ftho2n"` | no |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ansible-inventory | The ansible inventory file |
| ehost | The deployed border host's external IPv4 address |
| hosts | The deployed hosts' internal IPv4 addresses (separated with '\n') |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
