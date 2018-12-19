# kornsn_infra
kornsn Infra repository


## VPN

### Как подключиться к `someinternalhost`

В файл `/etc/hosts` внести внешний ip-адрес для хоста `bastion`.

Для подключения напрямую к `someinternalhost` использовать проксирование:

```bash
ssh ks@someinternalhost -o "ProxyCommand ssh ks@bastion -W %h:%p"
```

Или добавить в файл .ssh/config строку:
```
Host someinternalhost*
    ProxyCommand ssh ks@bastion -W %h:%p
```

Это позволит подключаться командой 
```bash
ssh ks@someinternalhost
```
ко всем хостам вида `someinternalhost*`.



bastion_IP = 35.210.161.51  
someinternalhost_IP = 10.132.0.3



## Деплой тестового приложения

testapp_IP = 35.205.147.55  
testapp_port = 9292


Создать виртуальную машину:
```bash
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family=ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=startup.sh
```

Создать правило firewall:
```bash
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags=puma-server --source-ranges=0.0.0.0/0
```



## Packer

Что сделано:

- Создано параметризированное описание базового образа `packer/ubuntu16.json`
- Создано параметризированное описание неизменяемого образа, содержащего все зависимости
  и код приложения `packer/immutable.json`
- Создан скрипт для запуска виртуальной машины из образа, подготовленного выше



## Terraform

Что сделано:

- Поднята виртуальная машина с тестовым приложением, используя terraform и созданный ранее базовый образ `reddit-base`

Задание со *:

- в метаданные проекта добавлены ssh-ключи для пользователей appuser1, appuser2.
 
> Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните
terraform apply и проверьте результат. Какие проблемы вы обнаружили?

При выполнении команды `terraform apply` ключ, добавленный вручную, был удалён.
Это не проблема, это лишь говорит о том, что все изменения нужно вносить через код и сохранять
в систему контроля версий.


Задание с **:

- Поднят балансировщик нагрузки TCP (см. файл tcp_lb.tf)
- Поднят балансировщик нагрузки HTTP (см. файл http_lb.tf)



## Terraform-2

1. Создано правило брандмауэра для ssh
2. Добавлен ресурс статического внешнего IP-адреса для приложения 
3. Подготовлены два образа ВМ в GCE с предустановленными Ruby и MongoDB. 
   - Созданы Packer-шаблоны app.json и db.json на основе ubuntu16.json
   - Доработан скрипт install_mongodb.sh для замены bindIP в конфигурационном файле mongod.conf на "0.0.0.0"
   - Построены образы reddit-app-base и reddit-db-base
4. Создана конфигурация Terraform для запуска приложения reddit и сервера БД в отдельных экземплярах ВМ
   - Основной конфигурационный файл Terraform разделён на 4 части: app.tf, db.tf, vpc.tf и main.tf
   - Добавлен ресурс статического внутреннего IP-адреса в db.tf
   - Изменен файл app.json для корректной работы провижинера
	    * добавлена input-переменная db_address для получения IP-адреса сервера БД 
	    * добавлен [источник данных](https://www.terraform.io/docs/configuration/data-sources.html) [*template_file*](https://www.terraform.io/docs/providers/template/d/file.html) для формирования systemd-юнита puma.service со строкой, передающей IP-адрес БД в переменную окружения DATABASE_URL
  	  * скорректирован провижинер для записи файла puma.service на сервер
   - Проверен запуск этих ВМ и корректная работа приложения
5. Конфигурации Terraform для ВМ и настройки сети перемещены в модули
6. Создана инфраструктура для двух окружений stage и prod с использованием модулей
7. Создан бакет для хранения состояния инфраструктуры в сервисе GCS
8. Настроено хранение состояния инфраструктуры в удалённом бекенде
9. Проверено создание блокировок при одновременном применении конфигурации


### Как проверить работу блокировок

При попытке повторного запуска `terraform apply` в то время, когда первая команда ещё выполняется,
получаем следующий вывод:
```bash
ks@ks ~/kornsn_infra/terraform/stage $ terraform apply
Acquiring state lock. This may take a few moments...

Error: Error locking state: Error acquiring the state lock: writing "gs://storage-bucket-kornsn-test/terraform/state/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1544099863588552
  Path:      gs://storage-bucket-kornsn-test/terraform/state/default.tflock
  Operation: OperationTypeApply
  Who:       ks@ks
  Version:   0.11.10
  Created:   2018-12-06 12:37:43.457557974 +0000 UTC
  Info:      


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```



## Ansible-1

Что сделано:
- установлен ansible с использованием virtualenv и pip
- написаны inventory файлы в формате ini и yaml
- написан файл конфигурации ansible.cfg
- написан скрипт `read_json_inventory.py` для чтения динамического inventory.
- написан плейбук `clone.yml` для клонирования репозитория
- исследовано поведение плейбука `clone.yml` при наличии требуемого репозитория на сервере
и при его отсутствии.

После удаления директории `~/reddit` и повторного примененения плейбука вывод изменился на 
```
appserver                  : ok=2    changed=1    unreachable=0    failed=0 
```
т.е. применение плейбука привело к изменениям на сервере, в отличие от запуска плейбука, когда репозиторий уже существовал
на сервере.


### Dynamic inventory
```
$ ansible all -m ping -i read_json_inventory.py 
35.205.81.188 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
35.187.187.14 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```



## Ansible-2

Что сделано:

- Созданы плейбуки:
    - один плейбук один сценарий
    - один плейбук много сценарииев
    - много плейбуков
- Сделана интеграция packer и ansible -- ansible использован как провижнер для packer
- Сделан динамический inventory с использованием плагина gcp_compute



## Ansible-3

Что сделано:

- Созданные ранее плейбуки app.yml и db.yml перенесены в отдельные роли app и db
- Описано два окружения prod и stage
- Использована community роль jdauphant.nginx для создания реверс-прокси для приложения
- Использована утилита ansible-vault для шифрования данных пользователей
- Добавлен плейбук для создания пользователей с использованием зашифрованных ранее данных
- В окружениях stage и prod используется динамический инвентори
