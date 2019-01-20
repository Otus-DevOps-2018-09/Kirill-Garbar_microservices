include .make_vars

default: build push

.DEFAULT:
	echo '\033[0;32m'"Please specify dockerhub user in .make_vars file. Use .make_vars.example"'\033[0m'

build: build_reddit build_monitoring build_logging
build_reddit: build_comment build_ui build_post build_source
build_monitoring: build_prometheus build_mongodb_exporter build_alertmanager build_grafana build_telegraf build_trickster build_autoheal
build_logging: build_fluentd

push: push_reddit push_monitoring
push_reddit: push_ui push_comment push_post push_source
push_monitoring: push_prometheus push_mongodb_exporter push_alertmanager push_grafana push_telegraf push_trickster push_autoheal
push_logging: push_fluentd

comment: build_comment push_comment
ui: build_ui push_ui
post: build_post push_post
source: build_source push_source
monitoring: build_monitoring push_monitoring
prometheus: build_prometheus push_prometheus
mongodb_exporter: build_mongodb_exporter push_mongodb_exporter
alertmanager: build_alertmanager push_alertmanager
grafana: build_grafana push_grafana
telegraf: build_telegraf push_telegraf
trickster: build_trickster push_trickster
autoheal: build_autoheal push_autoheal
fluentd: build_fluentd push_fluentd

build_comment:
	@echo $(delimiter) $@ $(delimiter)
	@cd src/comment && ./docker_build.sh

build_ui:
	@echo $(delimiter) $@ $(delimiter)
	@cd src/ui && ./docker_build.sh

build_post:
	@echo $(delimiter) $@ $(delimiter)
	@cd src/post-py && ./docker_build.sh

build_source:
	@echo $(delimiter) $@ $(delimiter)
	@cd src/source && ./docker_build.sh

build_prometheus:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/prometheus && \
	docker build -t $(USER_NAME)/prometheus .

build_mongodb_exporter:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/mongodb-exporter && \
	docker build -t $(USER_NAME)/mongodb-exporter:1.0 .

build_alertmanager:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/alertmanager && \
	docker build -t $(USER_NAME)/alertmanager .

build_grafana:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/grafana && \
	docker build -t $(USER_NAME)/grafana .

build_telegraf:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/telegraf && \
	docker build -t $(USER_NAME)/telegraf .

build_trickster:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/trickster && \
	docker build -t $(USER_NAME)/trickster .

build_autoheal:
	@echo $(delimiter) $@ $(delimiter)
	@cd monitoring/autoheal && \
	docker build -t $(USER_NAME)/autoheal .

build_fluentd:
	@echo $(delimiter) $@ $(delimiter)
	@cd logging/fluentd && \
	docker build -t $(USER_NAME)/fluentd .


push_ui:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/ui

push_comment:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/comment

push_post:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/post

push_source:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/source

push_prometheus:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/prometheus

push_mongodb_exporter:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/mongodb-exporter:1.0

push_alertmanager:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/alertmanager

push_grafana:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/grafana

push_telegraf:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/telegraf

push_trickster:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/trickster

push_autoheal::
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/autoheal

push_fluentd:
	@echo $(delimiter) $@ $(delimiter)
	@docker push $(USER_NAME)/fluentd
