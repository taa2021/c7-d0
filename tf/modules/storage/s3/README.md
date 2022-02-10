# s3

## Примечания к реализации

На выходе требуется s3-совместимое хранилище-корзина
и минимально-безболезненные параметры сервис-учетки для работы с ней.
У Я.Облака на текущий момент технически невозможно или весьма затруднительно (см. здесь: ["...with this approach you grant Editor role to folder not bucket. So you need one bucket per folder. Right?..."](https://github.com/yandex-cloud/terraform-provider-yandex/issues/19#issuecomment-545926981))
создать корзину без роли editor или больше на уровне каталога,
поэтому, чтобы не ставить (ввиду злоупотребления необоснованно завышенными привилегиями) 
под угрозу все объекты текущего каталога - под корзину заводим специализированный каталог.
В данном каталоге создаем сервис-учетку admin-а (требуется для включения версионирования данных корзины
в т.ч. для создания корзины: терраформ (провайдер яндекса) сначала создает объект, 
а потом меняет свойство версионирования),  создаем с участием данной учетки корзину,
но потом "наружу" для использования возвращаем параметры иной созданной сервис-учетки
с привелегиями меньше, чем admin. И нет, роли storage-admin, storage-uploader с ходу 
(с отладкой в несколько часов) использовать не получилось - пользователь снаружи не подключается 
(access denied), но отладка-решение данного вопроса выходят за рамки поставленной задачи.
Данные в корзине конечно-же прозрачно кодируем (неГОСТ-овским "шифрованием").

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
| [yandex_iam_service_account.bucket-acc-admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account.bucket-acc-uploader](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.bucket-admin-key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_iam_service_account_static_access_key.bucket-uploader-key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_kms_symmetric_key.bucket-skey](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_resourcemanager_folder.s3-folder](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder) | resource |
| [yandex_resourcemanager_folder_iam_member.acc-bucket-admin-acl](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.acc-bucket-uploader-acl](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_storage_bucket.bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket-is-versioning | Predicate: is versioning enabled for the s3-storage bucket | `bool` | `true` | no |
| bucket-name | The  AWS-compatible s3-storage's bucket name | `string` | n/a | yes |
| cloud-tags | The Terraform object's cloud tags/labels | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_key | The  AWS-compatible s3-storage's access key |
| bucket\_name | The  AWS-compatible s3-storage's bucket name |
| endpoint | The  AWS-compatible s3-storage bucket's web-endpoint |
| region | The  AWS-compatible s3-storage bucket's region |
| secret\_key | The  AWS-compatible s3-storage's secret key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
