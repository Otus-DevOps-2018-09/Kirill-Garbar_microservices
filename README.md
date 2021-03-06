# HW-12
## В процессе сделано.
- Установили докер
- Запустили контейнер hello world!
- Позапускали простейшие команды с контейнерами и образами.
- Создали образ из запущенного контейнера.
- Посмотрели параметры контейнера и образа. Определелили на их основе различия между контейнером и образом.
- Остановили все контейнеры, удалили все остановленные контейнеры, удалили все образы.

# HW-13
## В процессе сделано.
- Создали новый проект в GCP.
- Сконфигурировали gcloud на новый проект.
- Установили docker-machine. Средство для управления несколькими докер-хостами.
- Создали docker-host через gcloud.
- Повторили практику из лекции, пощупали изоляцию неймспейсов (PID, network).
- Запустили докер-в-докере.
- Создали Dockerfile с установкой монги, руби и т.д. для приложения reddit.
- Собрали образ, запустили его на docker-host, опубликовали в docker-registry, запустили локально.
- Посмотрели логи, проверили, что kill pid 1 уничтожает контейнер.
- Запустили, удалили, создали, проверили процессы.
- Вывели инфу о контейнере.
- Посоздавали папки и файлы, удалили контейнер, создали, проверили, что папки отсутствуют.
- Создали шаблон packer с ansible provisioner с установкой python, docker .
- Создали инфру через terraform.
- Создали ansible playbook с установкой python, docker, login в docker registry, загрузкой и запуском образа.

## Как проверить работоспособность.
- Забрать ветку docker-2.
- Перейти в директорию репозитория. Заполнить переменные variable.json. Выполнить packer build packer/reddit_docker.json.
- Перейти в директорию terraform. Заполнить переменные terraform.tfvars.
- Выполнить terraform init и terraform apply. Команда создаст бакет для хранения tfstate.
- Перейти в terraform/stage. Заполнить переменные terraform.tfvars.
- Выполнить terraform init && terraform apply (ключи пользователя appuser должны быть в домашней директории ~/.ssh). Запомнить app_external_ip.
- Настроить gce dynamic inventory и положить его в директорию stage.
- Перейти в директорию ansible и выполнить ansible-playbook playbooks/site.yml.
- Перейти в браузере по ссылке http://app_external_ip:9292. Проверить так же с другими нодами.

# HW-14
## В процессе сделано.
- Загрузили новые исходники нашего приложения, разделённые на модули.
- Написали по докерфайлу для каждого сервиса.
- Скачали образ монги, сбилдили образы с сервисами, создали сеть (bridge) для приложения.
- Запустили котнейнеры.
- Перезапустили контейнеры с новыми сетевыми алиасами без пересборки образов.
- Создал образы на базе ruby:alpine. Почистил мусор. Для публикации постов уже и так был образ на базе python:alpine.
- Добавили volume для mongodb. Теперь при перезапуске приложения посты не удаляются.
- Контейнер с сервисом comment не запускался из-за отсутствия gem tzinfo-data.
- Написал в travis просьбу разблокировать для меня debug режим. Увидел в логе ошибку. Добавил gem.

## Как проверить работоспособность.
- Забрать ветку docker-3.
- Перейти в директорию репозитория. Перейти в директорию src.
- Создать docker-host, на нём развернуть три образа командами (подставить юзера) :
```
docker pull mongo:latest
docker build -t $USER/post:1.0 ./post-py
docker build -t $USER/comment:3.0 ./comment
docker build -t $USER/ui:3.0 ./ui
```
- Создать контейнеры командами.
```
docker network create reddit
docker run -d --network=reddit --network-alias=post_db_newalias --network-alias=comment_db_newalias -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post_newalias -e "POST_DATABASE_HOST=post_db_newalias" $USER/post:1.0
docker run -d --network=reddit --network-alias=comment_newalias -e "COMMENT_DATABASE_HOST=comment_db_newalias" $USER/comment:3.0
docker run -d --network=reddit -p 9292:9292 -e "POST_SERVICE_HOST=post_newalias" -e "COMMENT_SERVICE_HOST=comment_newalias" $USER/ui:3.0
```
- Пройти по docker-host_ip:9292, проверить работу.


# HW-15
## В процессе сделано.
- Запускали контейнеры с разными встроенными драйверами: none, host, bridge.
- Создали две сети front_net и back_net.
- Посмотрели автоматически созданные правила iptables.
- Установили docker-compose. Написали основной конфиг и параметризовали его.
- Задал имя проекта в файле .env.
- Создал docker-compose.override.yml в следующей конфигурации: создал ещё один контейнер source, куда поставил git. При запуске контейнер монтирует тому, проверяет, является ли директория git репой и притягивает туда изменения из ветки microservices. После запуска source стартуют остальные контейнеры.

## Как задать имя проекта. 2 варианта.
- В переменных окружения. Я задал в файле .env.
- Ключом -p в docker-compose.

## Как проверить работоспособность.
- Забрать ветку docker-4.
- Перейти в директорию репозитория. Перейти в директорию src.
- Создать docker-host, на нём собрать 5 образов командами (подставить юзера):
```
docker pull mongo:latest
docker build -t $USER/post:1.0 ./post-py
docker build -t $USER/comment:1.0 ./comment
docker build -t $USER/ui:1.0 ./ui
docker build -t $USER/source:latest ./source
```
- Заполнить файл с переменными .env.
- Выполнить `docker-compose up -d`

# HW-16
## В процессе сделано.
- Создал образ пакер с докером.
- Терраформом создал ВМ.
- Запустили gitlab в контейнере (run_gitlab_container.yml), создал группу, проект.
- Запушили в репозиторий проекта наши исходники.
- Создали pipeline .gitlab-ci.yml.
- Создали контейнер gitlab-runner и в интерктивном режиме его зарегистрировали.
- Запустили pipeline, runner запустил контейнер, сбилдил приложение и прогнал простейшие тесты.

## Автоматизация создания раннеров. 2 варианта.
- Создал пакер образ с ансибл ролью gitlab-runner (runner.json).
- Ансиблом развернул два раннера (install_gitlab_runner.yml).
- Решил переделать терраформ под виртуалки только с докером (модуль) и в докере запускать и gitlab и оф.образ gitlab-runner.
- Споткнулся на том, что в тестовом проекте нам недоступно более одного статического IP. А у самого терраформа есть ограничение на условия (папка terraform2).
- В итоге просто создал две виртуалки для gitlab и для runner (папка terraform).
- Далее создал плейбук на запуск контейнера через dpcker-compose (run_runner_container.yml).
- В runner-docker-compose.yml создаётся два контейнера. Один сам раннер. Другой регистрирует этот раннер и сразу выключается. Т.е. на каждый раннер будет создаваться два контейнера. Так сделано, потому что у гитлаб раннера в entrypoint прописаны скрипты, куда параметром передаются command. Либо регистрируешь контейнер и он гаснет, либо запускаешь контейнер, а потом отдельным процессом регистрируешь. После запуска раннера через command у меня не получилось ещё одним процессом запустить регистрацию.
- Создание раннеров через роль менее проблемное.
- Ссылка на канал в слаке: https://devops-team-otus.slack.com/messages/CDBTZKP18/details/.

# HW-17
## В процессе сделано.
- Описали окружения.
- Сделали создание окружения staging по кнопке и наличию тэга с версией.
- Добавили создание динамического окружения на каждую ветку.
- Для задания со * выбрал вариант создания ВМ с помощью docker-machine. Взял докер-образ gcloud-sdk, поставил туда docker-machine и создал хост. Переменные для аутентификации в GCP создал в настройках gitlab.
- Сбилдил приложение docker-monolith, поменял Dockerfile. Его же использовал для тестирования, запушил в docker registry. Логин и пароль тоже настроил в переменных gitlab.
- Настроил джоб ручного удаления. В этом джобе не стал ставить docker-machine, поставил просто gcloud.

## Как проверить работоспособность.
- Забрать ветку gitlab-ci-2.
- Создать новую ветку, новый проект в gitlab, настроить переменные gitlab: CI_GCP_JSON_KEY, CI_GCP_PROJECT_ID, DOCKERHUB_LOGIN, DOCKERHUB_PASSWORD.
- Проверить выполнение джобов.

# HW-18
## В процессе сделано.
- Запустили Prometheus в докере из официального образа.
- Создали докерфайл, который из официального образа Prometheus с копированием нового конфига собирает кастомный образ.
- Собрали образы приложения и Prometheus.
- Добавили в docker-compose prometheus и убрали оттуда все инструкции build, т.к. собираем образы скриптами.
- Подняли контейнеры, проверили добавление новый targets.
- Подняли node-exporter. Софт для предоставления метрик о работе ОС Linux. При каждом изменении конфига прометея необходимо пересобрать образ.
- Задание со *. Добавил mongodb-exporter от percona. https://github.com/percona/mongodb_exporter. Создал докерфайл для сборки экспортера из исходника, т.к. уже имеющийся обновлялся полгода назад.
- Задание со *. Добавил blackbox-exporter для мониторинга микросервисов приложения. Софт проверяет код http 200.
- Задание со *. Создал makefile, который билдит и пушит все образы докера проекта. Пользователь настраивается в .make_vars. Пароль для докерхаба запрашивается из stdin. Добавил вывод сообщений зелёным шрифтом :)

## Как проверить работоспособность.
- Забрать ветку monitoring-1.
- Создать docker-host с помощью скрипта docker/create_docker_host.sh.example. Ввести актуальное имя проекта.
- Вызвать make из корня репы, предварительно созда и заполнив .make_vars. Команда создаст и запушит образы в докерхаб.
- Выпоонить docker-compose up -d. Поднимется приложение, prometheus и экспортеры.

## Ссылка на докер хаб с моими образами.
- https://hub.docker.com/u/kirillgarbar

# HW-19
## В процессе сделано.
- Создали докер-хост.
- Разделили docker-compose на два файла. С контейнерами приложения и с контейнерами мониторинга.
- Запустили cAdvisor. Это сервис отображения информации о работающих контейнерах, потреблении ресурсов и запущенных внури контейнеров процессах. Добавили в настройки prometheus target cAdvisor. В GCP нужно открыть порт 8080.
- Запустили grafana. В GCP нужно открыть порт 3000. Добавили вручную источник prometheus, загрузили дашборд из комьюнити.
- Добавили несколько метрик из приложения, rate ошибочных запросов. rate - производная функции по времени (показывает скорость изменения графика).
- Добавили мониторинг метрик бизнес логики. Счётчик комментариев и постов. Добавили скорость роста количества комментариев и постов за последний час.
- Добавили контейнер alertmanager и отправку алертов в наш канал slack.
- Добавили alert на условие down любого из контейнеров.

## Дополнительные задания.
- Поменял Makefile. Добавил возможность пообразной сборки. Добавил сборку и пуш всех образов из основных и доп.заданий.
- Поменял версии образов на актуальные.
- Добавил мониторинг docker engine. В cAdvisor метрик больше, я здесь не увидел поконтейнерных метрик, а только в целом за docker engine. Сравнивать с cAdvisor его некорректно. Конфиг в /etc/docker/daemon.json
`
{
  "metrics-addr" : "10.0.2.1:9323",
  "experimental" : true
}
`
- Добавил target в prometheus, добавил dashboard из комьюнити.
- Добавил мониторинг докера через telegraf от influxdb. Telegraf собирает метрики с разных источников и конвертирует их для разных получателей. Добавил дашборд из чужого репозитория, в комьюнити ничего не нашёл. :)
- Добавил рекомендованный алерт на превышение порога 95 процентилем времени ответа. Попрог вычислен опытным путём, чтобы алерты срабатывали иногда.
- Настроил alertmanager на отправку алертов на email. Интегрировал с google smtp через app password.
- Экспортировал дашборды, описал datasource, которые добавляются при старте контейнера.
- Настроил stackdriver в GCP. Добавил stackdriver-exporter. Ниже описаны метрики, который собираются в prometheus (метрики по instance и метрики по monitoring). Stackdriver аутентифицируется в GCP с помощью секретного JSON, который находится на докер-хосте. Проброшен в контейнер как секрет.
- Добавил бизнес метрику `votes_count (счётчик голосов)` в сервис post. Счётчик увеличивается при вызове функции "проголосовать". Добавил отображение графика rate() в графану. Счётчики обнуляются при перезапуске приложения, поэтому мониторить их в данном случае без rate не имеет смысла.
- Добавил техническую метрику `comments_read_db_seconds (время получения комментариев к посту)` типа гистограмма.
- Добавил trickster proxy, опубликовал на порт 9393. Полностью дублируется интерфейс prometheus, метрики доступны.
- Trickster публикует свои метрики на порт 8082.
- При выполнении задания AWX+autoheal нужно написать playbook для восстановения контейнеров. Я не захотел копировать docker compose, а весь запуск сервисов решил перенести в ansible. Более того, в модуле docker_service нельзя указать кастомный файл docker-compose.yml. Имя захардожено в Ansible. ВМ в ТФ создана на базе того же образа, что и autoheal. Образ с установленными docker и pip. В pip поставлены docker-compose и docker (питоновская либа). Потом понял, что можно было всё оставить в docker-compose (AWX генерирует dockr-compose.yml, который можно использовать). Всё равно для перезапуска сервисов, скорее всего, придётся писать отдельный playbook.
- Создал проект. Проект это то, что хранит плейбуки для запуска. Удобнее всего проект загружать из гита.
- Создал job template. Это плейбук из проекта из предыдщуего пункта, который запускается по событию.
- Добавил SSH credentials для подключения к машине с докер-контейнерами.
- GCE credentials для dynamic inventory. Сам скрипт получения инвентори уже есть в AWX.
- Inventory с источником GCE script.
- Для проекта нужна отдельная ансибл-инфра, т.к. в уже созданной никак не подтянуть переменные (ansible.cfg). Это либо отдельная ветка, либо отдельная репа.
- Сначала сделал старт контейнера через ансибл модуль docker-container. Не получилось, т.к. не смог найти, как сделать просто start существющего контейнера. Модулю нужна была конфигурация. В итоге сделал через модуль command.
- Конфиги с чувствительными данными (prometheus alerts и autoheal) копирую ансиблом на докер-хост и подключаю их как volume. Переменные зашифрованы ansible-vault.

## Какие метрики удалось собрать stackdriver-exporter.
stackdriver_gce_instance_compute_googleapis_com_firewall_dropped_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_firewall_dropped_packets_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_cpu_reserved_cores gauge
stackdriver_gce_instance_compute_googleapis_com_instance_cpu_usage_time gauge
stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_ops_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_read_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_read_ops_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_write_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_write_ops_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_ops_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_integrity_early_boot_validation_status gauge
stackdriver_gce_instance_compute_googleapis_com_instance_integrity_late_boot_validation_status gauge
stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count gauge
stackdriver_gce_instance_compute_googleapis_com_instance_uptime gauge
stackdriver_monitoring_api_calls_total counter
stackdriver_monitoring_last_scrape_duration_seconds gauge
stackdriver_monitoring_last_scrape_error gauge
stackdriver_monitoring_last_scrape_timestamp gauge
stackdriver_monitoring_scrape_errors_total counter
stackdriver_monitoring_scrapes_total counter

## Ссылка на докер хаб с моими образами.
- https://hub.docker.com/u/kirillgarbar

## Как проверить работоспособность.
- Забрать ветку monitoring-2.
- Вся инфра хранится в monitoring/infra.
- Пакером создать образ с докерхостом (docker.json), заполнив переменные.
- ТФом создать две ВМ `stage/awx-autoheal.tf` и `stage/reddit-monitoring.tf`.
- Выполнить make из корня репы, заполнив .make_vars (Или взять мои образы USERNAME=kirillgarbar).
- Заполнить переменные в Ансибл. В secret_vars.yml зашифрован пароль от учётки гугла и логин-пароль от AWX.
- Выполнить Ансибл playbook playbooks/main.yml.
- Создать проект в AWX с истоником https://github.com/Kirill-Garbar/start-containers и отсинкать.
- Создать job template.
- Добавить SSH credentials для подключения к машине с докер-контейнерами.
- Добавить GCE credentials JSON.
- Создать Inventory с источником GCE script и отсинкать.
- Выключить один из микросервисов (ui,post,comment) и ждать восстановления.

# HW-20
## В процессе сделано
- Новую версию приложения забрал и пересобрал в прошлых ДЗ. :)
- Поменял в docker-build тэги на logging. Поменял в .env файле версии сервисов на logging.
- Добавил в Makefile fluent.
- Подняли по инструкции EFK.
- Настроили docker-compose на вывод логов stdout в fluent.
- Добавили фильтр с гигантской регуляркой.
- Добавили грок-шаблоны. Стало выглядеть поприятнее.
- В качестве задания со * добавил ещё одну grok-схему в тот же фильтр.
- Запустил Zipkin последней версии (по рекомендации коллег-студентов в слаке).
- Воспроизвёл задержку отображения поста. Нашёл в коде хак, который тормозит пост на 3 секунды. Не совсем понял, каким образом мне должен был помочь Zipkin. Он помог только тем, что показал, что задержка в посте.
- Вернул оригинальный src, который был допилен в мониторинге дополнительными метриками.

## Как проверить работоспособность.
- Забрать себе репу с веткой logging-1.
- Выполнить make, заполнив переменные. Или пуропстить пункт и взять мои образы.
- Выполнить docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d
- Проверить zipkin и kibana.

# HW-21
## В процессе сделано
- Написали deployment для сервиса post.
- Написали deployment для других сервисов.
- Создал playbook для выполнение 2 и 3 шага инструкции the_hard_way (установка клиентских инструментов на локалхост и развёртывание сети, правил и самих ВМ). Посмотрел существующие ansible playbook. Сквозь многие таски проходит использование command/shell вместо модулей. Скорее всего, модулями какие-то вещи не сделать.
- Установили k8s по инструкции https://github.com/kelseyhightower/kubernetes-the-hard-way.
- Создали поды из созданных deployment.

## Как проверить работоспособность.
- Забрать ветку kubernetes-1.
- Заполнить системные переменные apache-libcloud.
- Выполнить `ansible-playbook 02-install-client-tools.yml` и `ansible-playbook 03-create-compute-resources.yml`.

# HW-22
## В процессе сделано
- Установили kubectl.
- Установил minikube на Linux. Потом на Windows. На Windows всплывали какие-то непонятные ошибки с загрузкой образов и я вернулся на Linux. Приложение проверял с помощью SSH-туннелирования.
- Создали deployments.
- Создали services.
- Добавили два алиаса-сервиса для монги, чтобы микросервисы post и comment могли найти БД. Так же добавили переменные в микросервисы, т.к. имена алиасов-сервисов не могут создержать нижнее подчёркивание.
- Посмотрели дашборд, немного поковырялись.
- Создали dev namespace. Запустили приложение в нём.
- Добавили переменную окружения в UI. В коде приложения эта переемнная выводится в шапке главной страницы.
- Развернули GKE, перенесли туда приложение и создали разрешающие правила.
- Ссылка на приложение http://35.195.114.21:32093/. Скриншот прикладывать не увидел практического смысла.
- Ссылка на дашборд http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy с помощью kubectl-proxy. Не понял, зачем он нужен в данном случае. У гугла есть свой встроенный с такой же (или похожей) функциональностью.
- В kubernetes/terraform/stage написал инфру для создания кластера.
- В манифесте dashboard-cluster-role-binding.yml описал биндинг роли cluster-admin на сервис акк kubernetes-dashboard. В TF включил dashboard.

## Как проверить работоспособность.
- Забрать ветку kubernetes-2.
- Выполнить `terraform apply` в kubernetes/terraform/stage.
- Настроить kubectl на удалённый кластер.
- Выполнить `kubectl apply -f .` в kubernetes/reddit.
- Создать разрешающие правила для приложения (Не стал их добавлять в конфу кбер-кластера).

# HW-23
## В процессе сделано
- Проверили работу kube-dns. Отключили kube-dns-autoscaler. Отключили kube-dns. DNS перестал работать.
- Сделали ui-service типа NodePort: открывается порт на всех нодах. Кубер сам решает, куда перенаправить запрос. Даже если пода нет на данной ноде, запрос всё равно дойдёт до пода.
- Сделали ui-service типа LoadBalancer: используется внешний балансировщик, который балансирует на NodePort, который создаётся автоматически.
- Сделали ingress для ui, перенаправили TCP. Для работы ingress нужен сервис с типом NodePort. Поменяли ingress на правило http.
- Создали tls-сертификат с ключом и на его основе создали секрет в кубере. В качестве задания со * описали его как манифест. Хранится в открытом виде. Убрали в ингрессе возможность работы по http.
- Включили сетевой плагин Calico, чтобы включить NetworkPolicy.
- Запретили обращаться к монге со всех подов, кроме comment. По факту у меня не получилось это сделать. Приложение всё равно работало. Но манифест для post я дописал :)
- У нас уже был подключён volume EmptyDir - создаваемый том при создании пода и удаляемый после удаления пода. Используется для обмена инфой между подами.
- Поменяли volume на предварительно созданый persistent диск в GCP.
- Создали манифест для persistent volume из уже созданного диска.
- Создали манифест для persistentVolumeClaim и подключили этот claim (заявку) к уже созданному деплойменту.
- Создали storageClass fast, который использует различные provisioner'ы. И в claim указали создание диска этого класса.

## Как проверить работоспособность.
- Забрать ветку Kubernetes-3.
- Выполнить `terraform apply` в kubernetes/terraform/stage.
- Настроить kubectl на удалённый кластер.
- Выполнить `kubectl apply -f dev-namespace.yml` в kubernetes/reddit.
- Выполнить `kubectl apply -f . -n dev` в kubernetes/reddit.
- Пройти по https://{ip}.

# HW-24
## В процессе сделано.
- Установили Helm. Контекст берётся из kubectl.
- Установили Tiller - серверную часть Helm. Устанавливается как pod. Права выдали с помощью RBAC.
- Написали шаблоны микросерисов (deployment, service, ingress). Создали релиз, удалили релиз. Добавили переменные, добавили values.yaml.
- Создали несколько релизов. Работают параллельно, не зависят друг от друга.
- Добавили _helpers.tpl. Написали функцию преобразования переменных в шаблонах.
- Создали Chart reddit, в котором указали относительные ссылки в ФС на чарты микросервисов.
- Добавили в Chart reddit зависимость от mongodb.
- Добавили в ui переменные-ссылки на сервисы post и comment (т.к. релизов много, надо, чтобы в service-discovery регистрировали имена с учётом релиза).
- Создали ещё один пул, состоящий из одной ноды. Включили устаревшие права доступа, т.к. gitlab пока не умеет работать с ролями. Установили gitlab-omnibus.
- Добавили в переменные гитлаба логин-пароль к докерхабу. Создали группу, проекты (ui, post, comment, reddit-deploy), загрузили туд исходники микросервисов и чарты reddit-deploy.
- Настроили gitlab-ci для микросервисов. Сделали автоматическое создание environment для review feature-ветки и деплой туда приложения (всех микросервисов). Environment feature-ветки можно удалить по кнопке.
- Настроили gitlab-ci для reddit-deploy. Сделали автоматическое создание environment staging и production и деплой в эти среды по кнопкам.
- Создал триггер для запуска основного пайплайна.
- В основном пайплайне staging сделал недоступным для запусков пайплайна по триггеру (по условию задачи). Не стал его удалять т.к. этот stage будет необходим для тестирования пайплайна при изменении самих чартов.
- В основном пайплайне production сделал недоступным для запусков пайплайны по событию push, чтобы не сделать релиз при изменении чарта. Хотя по условию задачи ветка master микросервисов всегда равна продакшну.
- В пайплайнах микросервисов добавил step trigger_deploy, в котором вызывается функция trigger_deploy(), в которой устанавливается curl и дёргается триггер запуска основного пайплайна.


# HW-25
## В процессе сделано.
- Добавил создание более мощного пула из предыдущего ДЗ -в terraform.
- Установили ингресс контроллер nginx. Добавили в хосты имена из этого ДЗ на выданный IP nginx.
- Загрузили чарт прометея, распаковали, отредактировали конфиг (переменные).
- Включили kube-state-metrics и node-exporter.
- Настроили service discovery по меткам.
- Настроили relabeling, чтобы метки кубера транслировались в метки прометея.
- Установили grafana. Импортировали дашборд из паблика, импортировали старые дашборды из ДЗ monitoring-2. Включили механизм темплейтинга через создание переменной.
- Параметризовали дашборды, созданные в ДЗ monitoring-2.
- Запустил alertmanager, настроил алерты в слак по падению api кубера (проверить не смог) и по падению ноды (проверил отключением ноды).
- Установил prometheus-operator. Директория kubbernetes/prometheus-operator. Настроил ingress для него. Настроил мониторинг всех post-сервисов из всех неймспейсов.
- Поставили label на наши мощные ноды, чтобы туда ставить elasticsearch.
- Загрузили yaml-файлы из предоставленных gist.
- Создал Helm-chart с установкой EFK. Идеально создать не вышло, т.к. в чарт Кибаны передаётся ссылка на Эластик, а ссылки я сделал типа релизов reddit, чтобы можно было поставить несколько EFK. Редактировать готовый чарт Кибаны посчитал лишним. Поэтому имя релиза захардкожено в переменных чарта.

## Как проверить работоспособность.
- Забрать ветку Kubernetes-5.
- Выполнить `terraform apply` в kubernetes/terraform/stage.
- Настроить kubectl на удалённый кластер.
- Набор команд, создающих Tiller, релизы приложений. Нужно перейти в kubernetes/Charts/reddit
```
kubectl apply -f ../../reddit/tiller.yml
helm init --service-account tiller
helm dep update
helm upgrade reddit-test . --install
helm upgrade production --namespace production . --install
helm upgrade staging --namespace staging . --install
helm install stable/nginx-ingress --name nginx
cd ..
cd prometheus && helm upgrade prom . -f custom_values.yaml --install
kubectl apply -f ../prometheus-operator/
kubectl apply -f ../prometheus-operator/
```
- Последнюю команду выполнять два раза, т.к. одна создаст api, другая создаст прометей и сервис монитор из этого api.
- Посмотреть IP, присвоенный nginx `kubectl get ingress`. Добавить в хосты:
```
IP_NGINX  prometheus-operator-prometheus prometheus reddit reddit-prometheus reddit-grafana production reddit-kibana efk-test-reddit-kibana reddit-test
```
