dev-apply:
	terraform init
	terraform apply -auto-approve -var-file=main.tfvars
dev-destroy:
	terraform destroy -auto-approve -var-file=main.tfvars
