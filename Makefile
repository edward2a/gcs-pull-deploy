### USER TARGETS ###

.PHONY: help
help:
	@echo "This will eventually be a help output"

.PHONY: build-pkg
build-pkg: output/gcs-pd.tar.gz

.PHONY: build-test-app-pkg
build-test-app-pkg:
	@cd test/app && make build-pkg

.PHONY: prepare-test
prepare-test: test-pkgs

test-pkgs: output/gcs-pd.tar.gz output/go-hello.tar.gz
	cp -v output/gcs-pd.tar.gz output/go-hello.tar.gz test/infra/files/

test: prepare-test

clean:
	rm -f output/*
	cd test/app && make clean
	cd test/infra && make clean

### FILE TARGETS ###

output/gcs-pd.tar.gz:
	[ ! -f output/gcs-pd.tar.gz ] || rm -f output/gcs-pd.tar.gz
	tar -f output/gcs-pd.tar.gz -czv -C scripts .

output/go-hello.tar.gz: build-test-app-pkg
	@cp test/app/output/pkg/go-hello.tar.gz output/
