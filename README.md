# kornsn_infra
kornsn Infra repository


## Как подключиться к `someinternalhost`
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

