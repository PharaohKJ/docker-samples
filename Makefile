DOCKER_IP=$(shell boot2docker ip 2>/dev/null)
FORWARD=5000

## help
help:
	@grep ^##.\* Makefile

## run
run:
	cd echo ; bundle exec puma hello.ru

## ebuild
ebuild:
	docker build -t kato/echo echo/

## pbuild
pbuild:
	docker build -t kato/proxy proxy/

## echo
test:
	curl http://$(DOCKER_IP):$(FORWARD)/
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/ping
	@echo
	curl -X POST -d 'data=xxx' http://$(DOCKER_IP):$(FORWARD)/echo
	@echo
