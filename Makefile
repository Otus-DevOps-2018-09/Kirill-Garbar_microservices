include .make_vars

default: build push

.DEFAULT:
	echo '\033[0;32m'"Please specify dockerhub user in .make_vars file. Use .make_vars.example"'\033[0m'

build: build_reddit build_monitoring

build_reddit: build_comment build_ui build_post build_source

build_comment:
	@cd src/comment && ./docker_build.sh

build_ui:
	@cd src/ui && ./docker_build.sh

build_post:
	@cd src/post-py && ./docker_build.sh

build_source:
	@cd src/source && ./docker_build.sh

build_monitoring: build_prometheus build_mongodb_exporter

build_prometheus:
	@cd monitoring/prometheus && \
	docker build -t $(USER_NAME)/prometheus .

build_mongodb_exporter:
	@cd monitoring/mongodb-exporter && \
	docker build -t $(USER_NAME)/mongodb_exporter .

push:
	@echo '\033[0;32m'"Input password for dockerhub. It will not be saved anywhere."'\033[0m'
	@docker login --username $(USER_NAME)
	@docker push $(USER_NAME)/ui
	@docker push $(USER_NAME)/comment
	@docker push $(USER_NAME)/post
	@docker push $(USER_NAME)/prometheus
	@docker push $(USER_NAME)/mongodb_exporter
