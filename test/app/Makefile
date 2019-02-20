code = go-hello
ldflags = '-s -w -linkmode external -extldflags "-static"'


output/${code}:
	@make build-in-docker

.PHONY: build
build:
	[ -d output ] || mkdir output
	go build -ldflags ${ldflags} -o output/${code} ${code}.go

.PHONY: build-in-docker
build-in-docker:
	docker run -ti --rm -v "$$PWD:/app" -w /app --env CALLER_UID=$(shell id -u) golang:1.11.1-alpine3.8 /bin/sh /app/scripts/build-alpine.sh

output/pkg/${code}.tar.gz:
	sh scripts/build-pkg.sh

.PHONY: build-pkg
build-pkg: output/${code} 
	@make output/pkg/${code}.tar.gz

.PHONY: clean
clean:
	[ ! -d output/pkg ] || rm -f output/pkg/*
	[ ! -d output/pkg ] || rmdir output/pkg
	rm -f output/*
