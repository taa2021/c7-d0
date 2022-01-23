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

Проверку-тестирование успешности развертывания производим "прямо в задании" на основе null-ресурса,
каждый раз при запуске 
```
terraform apply
```
Повторный запуск - допустим и даже необходим.

При проверке результата перенаправления балансировщиком трафика (и возврата результата)
необходимо учитывать, что "равномерность" балансировки фронтендом запросов на бекенды
обеспечивается в рамках теории вероятности.
Также необходимо учитывать, что ресурсы в облаке создаются не мнгновенно, 
вычислители "поднимаются" не мгновенно, и результат облачным провайдером "о готовности" ресурса (даже если
ресурс еще включается) может (на практике - всегда) вернуться до фактической готовности ресурса,
и для успешности прохождения проверки развертывания после непосредственно развертывания
непосредственно процедуру проверки необходимо повторить.

Ожидаемый эффект - как можно более простой переход на иную облачную платформу.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | = 1.1.3 |
| yandex | ~>0.70.0 |

## Providers

| Name | Version |
|------|---------|
| null | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| nlb | ../../../modules/network/nlb-simple-http | n/a |
| vpc-network | ../../../modules/network/vpc | n/a |
| vpc-subnets | ../../../modules/network/subnet | n/a |
| web-servers | ../../../modules/compute/host | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.check-results](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "environment": "dev", "terraform": true }``` | no |
| hosts | The setting templates for the cloud hosts | ```list( object({ region = string subnet = string image-family = string has-eaddr = bool ssh = string }))``` | ```[ { "has-eaddr": true, "image-family": "lemp", "region": "ru-central1-a", "ssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28 = ", "subnet": "192.168.1.0/28" }, { "has-eaddr": true, "image-family": "lamp", "region": "ru-central1-b", "ssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAHvfDvfxMVMfxvWVHoVik+m7xVfUC7RpThrDJAFpkc6qQHM/n3CV8aPny8b5zG86F7vuV0RxlOOLJZPEBeHW4MnCLE9uH+8kssioLyBekF/N8poewkzeNMAsx+rXt8PmZuLqthhdvjJaC9FNuqmjDzermNPv9RXR7FOpC6kKk3KlOszyiL0+/dIenQzyz//DG2AsAnnB3zKDEGAg+Nyo2Z0NFmuRKHNa0D0ezFMB34FPjw7eyBoYb/UwX46ANmPdqZGsi13up3tOAZ/uZdyZ2ksJ90vXrxEwi8J+8kEoKi+UYNpAjYAb4KVuPG+7aNgorC6i0nYHHJ7JJnsHbbNY+28 = ", "subnet": "192.168.1.16/28" } ]``` | no |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | `"b1gjilr27b0mqp90rj46"` | no |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | `"b1gjo8k8qajfr6ftho2n"` | no |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| hosts | The deployed hosts' external IPv4 addresses (separated with '\n') |
| hosts-port | The deployed hosts' external TCP port |
| nlb | The deployed network load balancer's external IPv4 address |
| nlb-port | The deployed network load balancer's external TCP port |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
