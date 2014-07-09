
## help
help:
	@grep ^##.\* Makefile

## run
run:
	bundle exec puma hello.ru

## echo
echo:
	curl -d 'data=xxx' http://localhost:9292/echo
