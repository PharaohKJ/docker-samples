DOCKER_IP=$(shell boot2docker ip 2>/dev/null)
FORWARD=5000
FORWARD2=5100
PUMA_PORT=9292

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
	cd echo ; bundle exec puma proxy.ru

## port
port:
	@boot2docker ip 2>/dev/null ; echo


## ebuild
ebuild:
	docker build -t kato/echo echo/

eclean: rmfall

eba: ebuild erun

## pbuild
pbuild:
	docker build -t kato/proxy proxy/

## erun
erun:
	docker run -d -p $(FORWARD):$(PUMA_PORT) kato/echo

## prun
prun:
	docker run -d -p $(FORWARD2):$(PUMA_PORT) kato/proxy

## rmall
rmall:
	docker rm `docker ps -a -q`

## rmfall
rmfall:
	docker rm -f `docker ps -a -q`

## echo
test:
	curl http://$(DOCKER_IP):$(FORWARD)/
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/ping
	@echo
	curl -X POST -d 'data=xxx' http://$(DOCKER_IP):$(FORWARD)/echo
	@echo
	curl http://$(DOCKER_IP):$(FORWARD)/entry
	@echo
