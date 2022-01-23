# B5.2.8 Итоговая практическая работа


## Задание

Комплексная, протяженная формулировка задания приведена [здесь](./TASK.md).
Ссылки на изначальные примеры решения подзадач оставлены преднамеренно -
при решении изучались, но не использовались.


## Примечания к решению

- "Аппаратные" характеристики развертываемых хостов уменьшены по срвнению с требуемыми согласно заданию -
в соответствии с требованиями Куратора курса об использовании минимально возможных ресурсов.

- После развертывания решения задания и сбора доказательств успешности развертывания ресурсы в Я.Облаке были удалены - 
в соответствии с требованиями Куратора курса об использовании минимально возможных ресурсов,
в соответствии с неоднократными заявлениями Ментора об отсутствии необходимости "держать включенными ресурсы"
только для проверки задания, а также о достаточности предоставления в качестве решения ссылки на репозиторий 
(и дополнительных подтверждающих материалов).

- При решении используемый для хранения состояний бекенд terraform на базе Я.Облака - AWS-совместимый,
и в качестве бэкенд-решения для Terraform поддерживает версионирование, но не поддерживает блокировку,- 
что необходимо учитывать при (многопользовательской) работе,
а также необходимо учесть при внешнем контроле соблюдения лючших практик развернутой инфраструктуры
(т.е. несоответствие best-practise в данном случае - для соответствия условиям задачи).
При этом в Я.Облаке достаточно сложная система предоставления прав использования ресурсов
без надлежащей документации, с противоречащими высказываниями в указанной документации.
Поэтому - в учебных целях - не в ущерб "общим вопросам безопасности" bucket создавался с админскими полномочиями,
но отдавались-к-дальнейшему использованию ключи сервисной записи с полномочиями редактора. 
"Зарезать" более существенно - с ходу не получилось, но вопрос выходит за рамки решения задачи (см. также соответствующее
описание [модуля S3](./modules/storage/s3/README.md)).

- При решении/развертывании токены сеанса Я.Облака, ключей сервис-аккаунта Я.Облачного бекенд-хранилища
Terraform задавались чере переменные среды окружения.

- Структура каталогов решения приведена в соответствии с рекомендациями
[Terraform: инфраструктура на уровне кода](https://www.litres.ru/brikman/terraform-infrastruktura-na-urovne-koda-pdf-epub-66828333/).
При этом из стадий жизненного цикла (пока есть) - только dev.

- Подразумевается, что для инфраструктуры жизненного цикла development, stage, production - бэкенды хранения состояний
terraform - разные, учетные записи облачных инфраструктур - разные.

## Ход решения (принципиальная схема развертывания)

0. [Запрашиваем токен для Я.Облака](https://cloud.yandex.ru/docs/iam/operations/iam-token/create),
результат экспортируем в переменной окружения
```
export TF_VAR_yc_iam_token=`yc iam create-token`
```
1. Создаем бекенд-хранилище для terraform данного проекта данной стадии жизненного цикла (dev)
```
cd (__GIT_PROJECT_ROOT__)/global/tf-state-storage
# правим значения параметров в variables.tf
#...
# инициализируем среду Terraform
terraform init
# просматриваем план развертывания
terraform plan
# если всё устраивает - развертываем
terraform apply
```
Результат развертывания - [здесь](https://disk.yandex.ru/d/l4e9TrDkCU4Lzw).
Вывод приведен отдельно:
```
Outputs:

access-key = "msXPzeP-pNfIWeawQUw9"
bucket-endpoint = "storage.yandexcloud.net"
bucket-name = "tf--c2-br-7--2"
bucket-region = "ru-central1-a"
secret-key = (sensitive value)
```
На доверенном терминале просматриваем в том числе секрето-чувствительные параметры,
ключи аутентификации для s3-хранилища бэкенда - экспортируем в переменных среды окружения.
```
terraform output -json
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'

```
2. Для развертываемого стенда проекта данной стадии жизненного цикла (dev) правим параметры развертывания
(variables.tf), параметры бекенда Terraform (при необходимости), проводим развертывание
```
cd (__GIT_PROJECT_ROOT__)/live/dev/app
# правим значения параметров в variables.tf
#...
# правим значения параметров S3-бекенда терраформ (main.tf)
#...
# инициализируем среду Terraform
terraform init
# просматриваем план развертывания
terraform plan
# если всё устраивает - развертываем
terraform apply
# внимательно смотрим на вывод и обрануживаем, что при развертывании
# тестирование (получение результатов развертывания для проверки задания Ментором курса) 
# в полномо объеме - не произведено,
# вызываем тестирование еще раз
terraform apply
```
    - Ход развертывания - [здесь](https://disk.yandex.ru/d/GxXIuhq5e9tDDQ).
    - Результат развертывания - [здесь](https://disk.yandex.ru/d/SpsMh-nLEQG0-g).
    - Ход повторного тестирования - [здесь](https://disk.yandex.ru/d/4PC_rMBwzAU-YA).
Отдельно вывод по результату развертывания:
```
Outputs:

hosts = <<-EOT
    51.250.9.202
    62.84.120.73
EOT
hosts-port = 80
nlb = "84.201.159.205"
nlb-port = 80

```
Отдельно итоговые результаты авто-тестирования:
```
null_resource.check-results: Destroying... [id=4218881410677423300]
null_resource.check-results: Destruction complete after 0s
null_resource.check-results: Creating...
null_resource.check-results: Provisioning with 'local-exec'...
null_resource.check-results (local-exec): Executing: ["/bin/bash" "-c" "echo \"!!!-> `date` start checking...\"\n\nf
unction webprint() {\n    descr=$1\n    addr=$2\n    port=$3\n    num=$4\n    seq $num | while read I; do\n        /
usr/bin/echo -e \"==================================\\n`date` ${descr} addr: ${addr}\"\n        curl -L http://$addr
:$port 2>/dev/null | html2text |  grep -v \"^$\" | head -n 2\n    done\n}\n\necho \"51.250.9.202\n62.84.120.73\" | w
hile read A; do webprint hst $A \"80\" 1; done;\necho \"84.201.159.205\"   | while read A; do webprint nlb $A \"80\"
  10; done;\n\necho \"!!!<- `date` end checking!\"\n"]
null_resource.check-results (local-exec): !!!-> Sat 22 Jan 2022 06:14:37 PM UTC start checking...
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:37 PM UTC hst addr: 51.250.9.202
null_resource.check-results (local-exec): ****** Welcome to nginx! ******
null_resource.check-results (local-exec): If you see this page, the nginx web server is successfully installed and
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:37 PM UTC hst addr: 62.84.120.73
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:37 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): ****** Welcome to nginx! ******
null_resource.check-results (local-exec): If you see this page, the nginx web server is successfully installed and
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:38 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): ****** Welcome to nginx! ******
null_resource.check-results (local-exec): If you see this page, the nginx web server is successfully installed and
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:38 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): ****** Welcome to nginx! ******
null_resource.check-results (local-exec): If you see this page, the nginx web server is successfully installed and
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:38 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:39 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:39 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:39 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): ****** Welcome to nginx! ******
null_resource.check-results (local-exec): If you see this page, the nginx web server is successfully installed and
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:40 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:40 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): ==================================
null_resource.check-results (local-exec): Sat 22 Jan 2022 06:14:40 PM UTC nlb addr: 84.201.159.205
null_resource.check-results (local-exec): [Ubuntu Logo]  Apache2 Ubuntu Default Page
null_resource.check-results (local-exec): It works!
null_resource.check-results (local-exec): !!!<- Sat 22 Jan 2022 06:14:41 PM UTC end checking!
null_resource.check-results: Creation complete after 4s [id=568860007681471169]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```

## Выводы по решению 

- Два хоста с ОС нужных семейств - развернуты, из Internet хосты - доступны.
- Сетевой балансировщик нагрузке - развернут, из Internet - доступен, балансировка - производится.
- Балансировка трафика производится по статистически равномерному распределению.
