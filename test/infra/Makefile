deploy: check-deps
	terraform plan -out plan.log
	terraform apply plan.log

check-deps:
	[ -f files/gcs-pd.tar.gz -a -f files/go-hello.tar.gz ]
