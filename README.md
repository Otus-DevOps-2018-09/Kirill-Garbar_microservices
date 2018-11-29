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
