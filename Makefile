.PHONY: help
help:
	@echo "This will eventually be a help output"

.PHONY: build-pkg
build-pkg: output/gcs-pd.tar.gz

output/gcs-pd.tar.gz:
	[ ! -f output/gcs-pd.tar.gz ] || rm -f output/gcs-pd.tar.gz
	tar -f output/gcs-pd.tar.gz -czv -C scripts .

