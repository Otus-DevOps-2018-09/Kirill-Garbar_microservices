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
