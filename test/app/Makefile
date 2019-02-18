code = hello
ldflags = '-s -w -linkmode external -extldflags "-static"'

.PHONY: build-static clean

build-in-docker:
	docker run -ti --rm -v "$$PWD:/app" -w /app --env CALLER_UID=$(shell id -u) golang:1.11.1-alpine3.8 /bin/sh /app/scripts/build-alpine.sh

build-static:
	[ -d output ] || mkdir output
	go build -ldflags ${ldflags} -o output/${code} ${code}.go

build:
	go build -o output/${code} ${code}.go

build-pkg: build-in-docker
	sh scripts/build-pkg.sh

clean:
	rm -f output/pkg/*
	rmdir output/pkg
	rm -f output/*
