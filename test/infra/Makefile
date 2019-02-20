deploy: check-deps
	terraform plan -out plan.log
	terraform apply plan.log
	terraform output > output.log

plan:
	terraform plan

check-deps:
	[ -f files/gcs-pd.tar.gz -a -f files/go-hello.tar.gz ]
	TF=$$(which terraform) && [ -x $${TF} ]
	terraform init

clean:
	terraform destroy -auto-approve
	rm plan.log output.log terraform.tfstate terraform.tfstate.backup*
