DOCKER_IP=$(shell boot2docker ip 2>/dev/null)
FORWARD=5000
FORWARD2=5100
PUMA_PORT=9292
ENV_NAME=echoenv


## help
help:
	@grep ^##.\* Makefile

## env
env:
	@echo export DOCKER_HOST=tcp://$(DOCKER_IP):2375

## elocal
elocal:
	cd echo ; bundle exec puma hello.ru

## elocal
plocal:
	cd proxy ; bundle exec puma proxy.ru

## port
port:
	@boot2docker ip 2>/dev/null ; echo


## ebuild
ebuild:
	docker build -t kato/echo echo/

## clean
clean: rmfall

## ebr ebuild->erun
ebr: ebuild erun

## pbr pbuild->brun
pbr: pbuild prun


## pbuild
pbuild:
	docker build -t kato/proxy proxy/

## erun
erun:
	docker run -d --name='kato_echo' -p  $(FORWARD):$(PUMA_PORT) kato/echo

## erun_no_proxy
erun_no_proxy:
	docker run -d --name='kato_echo_no_proxy' kato/echo

## prun
prun:
	docker run -d --name='kato_proxy' -p $(FORWARD2):$(PUMA_PORT) kato/proxy

## prun_link
prun_link:
	docker run -d --name='kato_proxy' --link  kato_echo_no_proxy:$(ENV_NAME)  -p $(FORWARD2):$(PUMA_PORT) kato/proxy

## rmall
rmall:
	docker rm `docker ps -a -q`

## rmfall
rmfall:
	docker rm -f `docker ps -a -q`

## etest
etest:
	curl http://$(DOCKER_IP):$(FORWARD)/
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/ping
	@echo
	curl -X POST -d 'data=xxx' http://$(DOCKER_IP):$(FORWARD)/echo
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/entry
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/ping2
	@echo

## ptest
ptest:
	curl http://$(DOCKER_IP):$(FORWARD2)/
	@echo
	curl http://$(DOCKER_IP):$(FORWARD2)/ping
	@echo
	curl -X POST -d 'data=xxx' http://$(DOCKER_IP):$(FORWARD2)/echo
	@echo
	curl http://$(DOCKER_IP):$(FORWARD2)/ping2
	@echo
	curl http://$(DOCKER_IP):$(FORWARD2)/entry
	@echo

## proxy
proxy: ebuild pbuild erun_no_proxy prun_link
	curl http://$(DOCKER_IP):$(FORWARD2)/ping2
	@echo
