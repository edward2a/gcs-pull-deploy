KEEP_ENV = 0
BC_BLU = \e[44m
BC_RST = \e[49m

### USER TARGETS ###

.PHONY: help
help:
	@echo -e "${BC_BLU}This will eventually be a help output${BC_RST}"

.PHONY: build-pkg
build-pkg: output/gcs-pd.tar.gz

.PHONY: build-test-app-pkg
build-test-app-pkg:
	@cd test/app && make build-pkg

.PHONY: prepare-test
prepare-test: test-pkgs

test-pkgs: output/gcs-pd.tar.gz output/go-hello.tar.gz
	@echo -e "\n\t${BC_BLU}Copying deployment packages to infra test location...${BC_RST}\n"
	cp -v output/gcs-pd.tar.gz output/go-hello.tar.gz test/infra/files/

test: prepare-test
	@echo -e "\n\t${BC_BLU}Deploying infrastructure...${BC_RST}\n"
	@cd test/infra && make deploy
	@echo -e "\n\t${BC_BLU}Waiting a few seconds to make sure go-hello is deployed...${BC_RST}\n"
	@sleep 10s
	@echo -e "\n\t${BC_BLU}Executing test...${BC_RST}\n"
	@ENDPOINT=$$(cd test/infra && terraform output test_endpoint) && \
	echo -e "\n\t${BC_BLU}TEST ENDPOINT: $${ENDPOINT}${BC_RST}\n" && \
	echo -e "\n\t${BC_BLU}" && \
	curl -sf http://$${ENDPOINT} && echo -e "${BC_RST}"
	@if [ ${KEEP_ENV} -eq 0 ]; then \
		echo "\n\t${BC_BLU}Cleaning up test environment...${BC_RST}\n"; \
		make clean; \
	fi

clean:
	rm -f output/*
	cd test/app && make clean
	cd test/infra && make clean

### FILE TARGETS ###

output/gcs-pd.tar.gz:
	@echo "\n\t${BC_BLU}Building gcs-pd deployment package...${BC_RST}\n"
	[ ! -f output/gcs-pd.tar.gz ] || rm -f output/gcs-pd.tar.gz
	tar -f output/gcs-pd.tar.gz -czv -C scripts .

output/go-hello.tar.gz: build-test-app-pkg
	@echo "\n\t${BC_BLU}Building go-hello deployment package...${BC_RST}\n"
	@cp test/app/output/pkg/go-hello.tar.gz output/
