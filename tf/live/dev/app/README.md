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

## Modules

| Name | Source | Version |
|------|--------|---------|
| hosts | ../../../modules/compute/host | n/a |
| vpc-network | ../../../modules/network/vpc | n/a |
| vpc-subnet | ../../../modules/network/subnet | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "environment": "dev", "terraform": true }``` | no |
| hosts | The setting templates for the cloud hosts | ```list( object({ image-family = string has-eaddr = bool login = string }))``` | ```[ { "has-eaddr": true, "image-family": "ubuntu-2004-lts", "login": "ruser0" } ]``` | no |
| ssh\_pub\_key\_default | The ssh public key for the cloud hosts | `string` | n/a | yes |
| subnet | Yandex.Cloud zone default | `string` | `"192.168.1.0/28"` | no |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | n/a | yes |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | n/a | yes |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| hosts | The deployed hosts' external IPv4 addresses (separated with '\n') |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
