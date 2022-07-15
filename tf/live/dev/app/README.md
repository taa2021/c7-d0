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
| bastions | ../../../modules/compute/host1 | n/a |
| dns-k8s-rs0 | ../../../modules/network/dns-record | n/a |
| dns-k8s-rs1 | ../../../modules/network/dns-record | n/a |
| dns-srv-rs0 | ../../../modules/network/dns-record | n/a |
| dns-srv-rs1 | ../../../modules/network/dns-record | n/a |
| dns-zone-k8s | ../../../modules/network/dns-zone | n/a |
| dns-zone-srv | ../../../modules/network/dns-zone | n/a |
| k8s-masters | ../../../modules/compute/host2 | n/a |
| k8s-masters-drives | ../../../modules/storage/ldrive | n/a |
| k8s-nlb | ../../../modules/network/nlb-simple-http | n/a |
| k8s-workers | ../../../modules/compute/host2 | n/a |
| k8s-workers-drives | ../../../modules/storage/ldrive | n/a |
| vpc-network | ../../../modules/network/vpc | n/a |
| vpc-sg | ../../../modules/network/vpc-sg | n/a |
| vpc-sg-app | ../../../modules/network/vpc-sg | n/a |
| vpc-sg-self | ../../../modules/network/vpc-sg-self | n/a |
| vpc-subnet | ../../../modules/network/subnet | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_inner\_port | The inner port on k8s nodes for the app | `number` | n/a | yes |
| bastions | The setting templates for the cloud hosts | ```list( object({ image-family = string has-eaddr = bool mem = number ncpu = number }))``` | ```[ { "has-eaddr": true, "image-family": "ubuntu-2004-lts", "mem": 6, "ncpu": 4 } ]``` | no |
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | ```{ "environment": "dev", "terraform": true }``` | no |
| deploy\_stage | Deploy stage | `string` | `"dev"` | no |
| dev\_k8s\_nbd\_size | The k8s dev cluster drive's size | `number` | n/a | yes |
| dns\_bastion0\_aliases | DNS-name of the cnames for the bastion0l host | `string` | n/a | yes |
| dns\_zone\_k8s | DNS-name of the k8s zone | `string` | n/a | yes |
| dns\_zone\_srv | DNS-name of the srv zone | `string` | n/a | yes |
| k8s\_masters | The setting templates for the cloud hosts | ```list( object({ image-family = string has-eaddr = bool mem = number ncpu = number }))``` | ```[ { "has-eaddr": false, "image-family": "ubuntu-2004-lts", "mem": 4, "ncpu": 4 } ]``` | no |
| k8s\_workers | The setting templates for the cloud hosts | ```list( object({ image-family = string has-eaddr = bool mem = number ncpu = number }))``` | ```[ { "has-eaddr": false, "image-family": "ubuntu-2004-lts", "mem": 4, "ncpu": 4 } ]``` | no |
| ssh\_login\_default | The ssh login for the cloud hosts | `string` | n/a | yes |
| ssh\_pub\_key\_default | The ssh public key for the cloud hosts | `string` | n/a | yes |
| subnet | Yandex.Cloud zone default | `string` | n/a | yes |
| yc\_cloud\_id | Yandex.Cloud ID default | `string` | n/a | yes |
| yc\_folder\_id | Yandex.Cloud Folder ID default | `string` | n/a | yes |
| yc\_iam\_token | Yandex.Cloud IAM-token for the provider auth. Attention: don't set directly in a tracked git-file | `string` | n/a | yes |
| yc\_zone | Yandex.Cloud zone default | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_ext\_access | The App's params for the external access |
| bastions | The deployed hosts - bastions |
| cidr\_subnet | Local subnet's cidr |
| k8s\_masters | The deployed hosts - k8s masters |
| k8s\_workers | The deployed hosts - k8s workers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
