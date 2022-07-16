# ДИПЛОМНЫЙ ПРОЕКТ (HW-04)

## Задание

- Оригинальная формулировка задания приведена [здесь](./TASK.md).
- Результаты анализа задания исполнителем по ходу текста формулировки задания приведен [здесь](./TASK-with-comments.md).


## Примечания к решению

- Неиспользование специализированных решений поставщика облачных решений продиктовано требованиями задания.
- Использование по требованию задания псевдо-"baremetal"-решения накладывает свои достаточно существенные ограничения.
- Повсеместное использование ansible при развертывании продиктовано требованиями задания.
- Общий прицип развертывания:
  - (авто) разворачиваем "аппаратную" инфраструктуру;
  - (авто) на "аппаратную" инфрастуктуру развертываем (разные) k8s-кластеры (обслуживающий и прикладной), на обслуживающем сервере обеспечиваем удобство администрирования инфраструктуры и/или контроля работы (утилиты работы с k8s, vpn);
  - (авто) в кластеры - (до)разворачиваем необходимые сервисы (мониторинг, управление журналами логгирования, сервис запуска github action runner (self-hosted), устойчивую к сбою подсистему хранения, СУБД PostgreSQL);
  - (вручную) в обслуживающем кластере в подсистему наблюдения мониторинга-журналирования grafana добавляем "приемник получения уведомления" (токен, идентификатор канала для telegram), настраиваем непосредственно критерии сработки уведомлений ("alerts") исходя из (значимых) метрик мониторинга;
  - (вручную) в репозитории прикладного приложения - добавляем helm-chart, github-action, semver-тегируем коммиты при необходимости авторазвертывания приложения в прикладной кластер.
- Terraform - состояние инфраструктуры хранится в S3-совместимой корзине; по результату развертывания формируется файл инвентаря для последующих этапов развертывания.
- Ограничение сетевого доступа (аналог межсетевого экрана) для развертываемой инфраструктуры обеспечивается группами безопасности, доступ к тестированию функционала Я.Облака -  получен в ТП по запросу.
- Обслуживающий сервер srv - настраиваем как бастион (ssh) и/или входную точку доступа VPN (wireguard).
- Обслуживающий кластер k8s (на srv) - на базе сопровждаемого со стороны Ubuntu штатного microk8s (в кластерном режиме; при необходимости - добавление узлов в кластер возможно).
- Прикладной кластер k8s (master, app/worker) - развертывается на базе kubespray-решения.
- На клиентском компьютере (инженера, разработчика) при подключении по VPN веб-интерфейсы grafana, prometheus - доступны (по доменному имени).
- Нестандартные порты выше 1024 с недостаточной плотностью использования ingress для сервисов кластеров, необходимость использования в прикладном кластере подсистемы хранения на базе NBD - негативные последствия работы в рамках псевдо-"baremetal"-решения.
- Подсистема хранения логов - Grafana Loki - в двух экземплярах (под данные кластера обслуживания и под данные прикладного кластера) - развернута в кластере обслуживания; "сообщения" в данную подсистему от прикладного кластера push-аются promtail-ом прикладного кластера. Разделение на разные экземпляры - позволяет использовать разную политику хранения и обеспечивает удобное прозрачное осмысленное (без доп.фильтрации) использование сторонних дашбордов (из маркетплейса grafana).
- Подсистема мониторинга - Prometheus - в двух экземплярах (под данные кластера обслуживания и под данные прикладного кластера) - развернута в кластере обслуживания; "сообщения" в данную подсистему от прикладного кластера pull-ятся prometheus-ом (с ограниченным очищенным списком источников данных) с (иного) prometheus-а,развернутого на прикладном кластере.
- Подсистема визуализации информации мониторинга, логгирования Grafana развернута на обслуживающем кластере. Для данной подсистемы при развертывании автоматически подгружаются преднастроенные дашборды и источники данных (loki и prometheus обслуживающего кластера, loki и prometheus - _данных_ прикладного кластера (данные хранятся (для promethtus - в том числе хранятся) в обслуживающем кластере - согласно требованию задания)).
- Прикладное приложение (testapp): container image создается и сохраняется в github registry в рамках github action; в рамках того же процесса github action приложение (helm chart) push-ается (runner - self-hosted в обслуживающем кластере) в прикладной кластер; для helm параметры развертывания разворачиваются в соответствющие файлы в рамках того же github action.
- В Я.Облаке балансировщики в открытом доступе - только внешние (для внутренних ресурсов); механизмы сетевой абстракции (на базе L2 OSI/ARP) для baremetal-решения в псевдо-baremetal Я.Облака - не работают, использование metallb,portlb, kube.vip и аналогичных решений - не представляется возможным, при этом использование решений на базе BGP - чрезмерное усложнение решение, при этом использование manage-вариантов от Я.Облака не удовлетворяет требованиям задания. С учетом приведенной информации, в решении повсеместно ипользуются ресурсы с вариантом предоставления внешнего доступа как NodePort; необходимость корректности обработки данной ситуации учитывается в приведенном решении (например, опрос prometheus-а прикладного кластера пытается производится по обоим (или более) адресам узлов кластера, но отвечать будет только один (и дублирования информации - не происходит)). Доступ к pod-ам приложения из Internet обеспечен через яндекс network load balancer.
- Автоматизированные компоненты решения - идемпотентны; в том числе могут использоватья при расширении кластера (при уменьшении - с учетом особенностей работы kubesrpay).
- Решение - устойчиво (прикладное приложение продолжает работать в Inernet) к сбоям сервера обслуживания, одного из узлов прикладного кластера.
- Чувствительная информация хранится и передается в закодированном виде: для ansible - в виде vault-строк (удобнее контролировать набор данных по сравнению с шифрованием на уровне файла переменных), для github - secrets-значений уровня репозитория.
- Контроль корректности выбора стенда для развертывания - на основе требования указания имени стенда в имени файла инвентаря ansible (dev) - в том числе обеспечивается специализированной задачей при запуске playbook.

## Ход решения (принципиальная схема развертывания)

0. Устанавливаем относительно свежую версию ansible (тестировалось на 2.12.6) - через репозиторий launchpad или pip,  локально поддержку ansible-коллекций, обеспечиваем получение yandex [oauth-токена](https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)
```
...
ansible-galaxy collection install kubernetes.core community.general
...
```

1. Правим настройки развертывания
```
for f in  ansible-0-provision-playbook.yml ansible-0-provision-vars.yml ansible-1-deploy-vars.yml ansible-2-deploy-vars.yml; do vim $f; done
```

2. Создаем серверы для решения [задания](./TASK.md), автогенерируем [инвентарь ansible](./ansible-1-deploy-inventory.dev.txt) и [настройки ssh-подключения](./ansible-1-deploy-ssh.dev.config) для созданных хостов следующего шага
```
time ansible-playbook -i ansible-0-provision-inventory.dev.txt -e @ansible-0-provision-vars.yml ansible-0-provision-playbook.yml  | tee out/ansible-0-provision-apply.log
```

3. Настраиваем серверы, развертываем кластеры в соответствии с критериями [задания](./TASK.md) (необходимость задействования режима повышенных привелегий become продиктована использованием комбинированного ansible-playbook-сценария)
```
time ansible-playbook --become -i ansible-1-deploy-inventory.dev.txt -e @ansible-1-deploy-vars.yml ansible-1-deploy-playbook.yml | tee out/ansible-1-deploy-apply.log; date
```

4. Настраиваем кластеры в соответствии с критериями [задания](./TASK.md)
```
time ansible-playbook -i ansible-1-deploy-inventory.dev.txt -e @ansible-2-deploy-vars.yml ansible-2-deploy-playbook.yml | tee out/ansible-2-deploy-apply.log; date
```

5. Добавляем в подсистему визуализации данных мониторинга и журналирования Grafana (обслуживающий кластер) поддержку telegram (см. [1](https://sarafian.github.io/low-code/2020/03/24/create-private-telegram-chatbot.html), [2](https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id)), шаблоны уведомлений, критерии сработки уведомлений в соответствии с критериями [задания](./TASK.md). Ориентируемся на скриншоты [1](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_message_template_2022-07-16_01-34-38.png), [2](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_telegram_2022-07-16_01-35-10.png), [3](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-00-pool-free_2022-07-16_01-31-20.png), [4](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-01-app0-response-time_2022-07-16_01-32-04.png), [5](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-02-app0-status-code_2022-07-16_01-32-37.png), [6](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_srv-00-fs-free_2022-07-16_01-33-24.png)

6. Добавляем в репозиторий прикладного приложения разработанный каталог helm-chart-а (см. [1](https://github.com/taa2021/sf-testapp/tree/master/charts/app)), файл workflow для github action (см. [2](https://github.com/taa2021/sf-testapp/blob/master/.github/workflows/ci-cd.yml)), константы элементов чувствительной информации (см. [3](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_6__2022-07-16_02-41-24.png))

7. Форсируем передачу информации о тегах репозитория локально дорабатываемого прикладного приложения в удаленный репозитори. Получаем: формирование образа контейнера в github-реестре удаленного репозитория, развертывание helm-chart-а прикладного приложения в прикладной k8s кластер, например:

```
git tag v0.0.9
git push --tags

```

8. Итоги развертывания:
- скриншот работающего сайта прикладного приложения - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/app0_web_2022-07-16_01-58-12.png);
- ход развертывания серверов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/ansible-0-provision-apply.log);
- ход настройки серверов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/ansible-1-deploy-apply.log);
- ход настройки кластеров - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/ansible-2-deploy-apply.log).

9. Скриншоты подтверждения:

	1. Графана - добавление шаблона уведомления  - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_message_template_2022-07-16_01-34-38.png?raw=true)
	1. Графана, панель ("дашборд") Alert - пред-уведомительный режим при сработке критерия  - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_on_app_crash_0__2022-07-16_01-47-03.png?raw=true)
	1. Графана, раздел уведомлений - пред-уведомительный режим при сработке критерия - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_on_app_crash_1__2022-07-16_01-47-40.png?raw=true)
	1. Графана, панель Alert - уведомтельный режим при сработке критерия [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_on_app_crash_2__2022-07-16_01-49-37.png?raw=true)
	1. Телеграмм, сработавшие примеры уведомлений о сработке критерия и восстановлени штатного режима - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_on_app_crash_3__telegram__2022-07-16_01-55-41.png?raw=true)
	1. Графана, настройка Телеграмм - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerting_telegram_2022-07-16_01-35-10.png?raw=true)
	1. Графана, раздел уведомлений - перечень настроенных уведомлений согласно притериям [задания](./TASK.md) - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_all_2022-07-16_01-30-43.png?raw=true)
	1. Графана, настройка уведомления критерия "Свободное место подсистемы хранения в прикладном кластере" - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-00-pool-free_2022-07-16_01-31-20.png?raw=true)
	1. Графана, настройка уведомления критерия "Отклик сайта прикладного приложения" - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-01-app0-response-time_2022-07-16_01-32-04.png?raw=true)
	1. Графана, настройка уведомления критерия "Код возврата сайта прикладного приложения" - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_dev-02-app0-status-code_2022-07-16_01-32-37.png?raw=true)
	1. Графана, панель Alert - перечень наблюдаемых критериев - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_pannel_2022-07-16_01-25-21.png?raw=true)
	1. Графана, настройка уведомления критерия "Свободное место на сервере srv"  - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/alerts_srv-00-fs-free_2022-07-16_01-33-24.png?raw=true)
	1. k9s, прикладной кластер, описание pod прикладного приложения с отображением версии (репозиторий, тег/версия) образа контейнера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/app0_pod_container_image_and_tag__2022-07-16_02-22-25.png?raw=true)
	1. Сайт прикладного приложения - открывается - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/app0_web_2022-07-16_01-58-12.png?raw=true)
	1. Графана, панель наблюдения за состоянием прикладного кластера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/dev-kube_cluster_via_Prom_2022-07-16_01-15-04.png?raw=true?raw=true)
	1. Графана, панель наблюдения логов - в частности здесь - прикладного приложения - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/dev-logs_2022-07-16_01-24-15.png?raw=true)
	1. Github, actions, CI/CD workflow - доказательство сработки только для тегированных версий - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_0__2022-07-16_02-21-26.png?raw=true)
	1. Github, actions, CI/CD workflow - общий вид с длительностью выполнения  - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_1__2022-07-16_02-25-07.png?raw=true)
	1. Github, actions, CI/CD workflow - доказательство размешения в реестре образов контейнеров образа прикладного приложения с конкретной версией (тегом), соответствующей версии приложения в репозитории github - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_2__2022-07-16_02-26-31.png?raw=true)
	1. Github, actions, CI/CD workflow - доказательство использования при развертывании helm-chart версии (тэга) контейнера образа, "которая только что построена" и соответсвует версии приложения в репозитории github,- [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_3__2022-07-16_02-27-04.png?raw=true)
	1. Github, отображение sefl-hosted runners - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_4__2022-07-16_02-28-47.png?raw=true)
	1. Github, реестр образов контейнеров - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_5__2022-07-16_02-40-29.png?raw=true)
	1. Github, раздел задания параметров с чувствительной информацией - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_6__2022-07-16_02-41-24.png?raw=true)
	1. Github, раздел отображения тэгов (версий) прикладного приложения - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/github-CI-CD_7__2022-07-16_02-43-28.png?raw=true)
	1. k9s, прикладной кластер, отображение узлов кластера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_dev_nodes_2022-07-16_02-45-58.png?raw=true)
	1. k9s, прикладной кластер, перечень POD-ов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_dev_pods_2022-07-16_01-59-30.png?raw=true)
	1. k9s, прикладной кластер, перечень PVC-ов кластера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_dev_pvc-0_2022-07-16_02-01-07.png?raw=true)
	1. k9s, прикладной кластер, yaml-описание PVC для СУБД PostgreSQL - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_dev_pvc-1_2022-07-16_02-01-30.png?raw=true)
	1. k9s, прикладной кластер, перечень service-ов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_dev_services_2022-07-16_02-00-27.png?raw=true)
	1. k9s, обслуживающий кластер, перечень узлов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_srv_nodes_2022-07-16_02-45-06.png?raw=true)
	1. k9s, обслуживающий кластер, перечень POD-ов - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_srv_pods_2022-07-16_02-02-16.png?raw=true)
	1. k9s, обслуживающий кластер, перечень service-ов стр.1 - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_srv_services-0_2022-07-16_02-03-27.png?raw=true)
	1. k9s, обслуживающий кластер, перечень service-ов стр.2  - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/k9s_srv_services-1_2022-07-16_02-03-48.png?raw=true)
	1. Графана, перечень панелей (дашбордов) мониторинга - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/pannels_2022-07-16_01-26-51.png?raw=true)
	1. Prometheus, обслуживающий кластер, экземпляр мониторинга прикладного кластера (экземпляр удаленного Prometheus штатно виден только по одному из возможных адресов - узлов кластера) - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/prom-dev.srv.dev.local_2022-07-16_02-06-33.png?raw=true)
	1. Prometheus, обслуживающий кластер, экземпляр мониторинга обслуживающего кластера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/prom-srv.srv.dev.local_2022-07-16_02-06-03.png?raw=true)
	1. Графана, перечень (автоподгруженных) источников - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/srv-datasources-0list_2022-07-16_02-16-13.png?raw=true)
	1. Графана, обслуживающий кластер, панель мониторинга - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/srv-kube_cluster_via_Prom_2022-07-16_01-18-08.png?raw=true)
	1. Графана, обслуживающий кластер, панель контроля логов обслуживающего кластера - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/srv-logs_2022-07-16_01-22-56.png?raw=true)
	1. Графана, обслуживающий кластер, панель наблюдения сервера srv (NodeExporterFull) - [здесь](https://github.com/taa2021/c7-d0/blob/main/out/screenshots/srv-NodeExporterFull_2022-07-16_01-21-49.png)

  


## Информация для проверки задания

- Репозитории для проверки:
  - настройки инфраструктуры - [здесь](https://github.com/taa2021/c7-d0/)
  - прикладного приложения - [здесь](https://github.com/taa2021/sf-testapp)
- Ссылки на скриншоты дэшбордов мониторинга, реализации сборки логов, алертинга - приведены в разделе 9 "Скриншоты подтверждения" по ссылке [здесь](https://github.com/taa2021/c7-d0/blob/main/README.md)
- Адрес работающего приложения - [http://62.84.112.65/](http://62.84.112.65/)
- А также:
  - описание принципов, порядка развертывания - [здесь](https://github.com/taa2021/c7-d0/blob/main/README.md)
  - результаты анализа исполнителем задания с отметкой позиций (в тексте самого задания), оказавших влияние на предлагаемое решение,- [здесь](https://github.com/taa2021/c7-d0/blob/main/TASK-with-comments.md)

