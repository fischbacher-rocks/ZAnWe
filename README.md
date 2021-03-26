# ZAnWe

Zabbix-Ansible-Webhook

```sh
docker run -d \
  --name=zanwe \
  -e TZ=Europe/Vienna \
  -v /zanwe:/zanwe:ro \
  -p 9000:9000 \
  --restart always \
  rockaut/zanwe \
  # additional webhook args (-verbose -hotreload already there)
```
