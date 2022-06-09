#!make

tf_development = ./
# tf_tests = ./Infrastructure/tests

tf-validate:
	@if terraform fmt -check -diff -recursive  $(tf_development); then \
		echo "Terraform files all formatted correctly"; \
	else \
		echo "Formatting errors found, run tf-format to fix automatically"; \
		exit 1; \
	fi
	@cd $(tf_development) && terraform init -backend=false && terraform validate

tf-plan: tf-format tf-validate
	@cd $(tf_development) && \
		terraform init && \
		terraform plan -var-file=./environments/local_defaults.tfvars -var-file=credentials.tfvars -lock=false

tf-deploy: tf-format tf-validate
	@cd $(tf_development) && \
		terraform init && \
		terraform apply -auto-approve -var-file=./environments/local_defaults.tfvars -var-file=credentials.tfvars -lock=false

tf-destroy:
	@cd $(tf_development) && \
		terraform destroy -var-file=./environments/local_defaults.tfvars -var-file=credentials.tfvars -lock=false

tf-format:
	@terraform fmt -recursive $(tf_development)

# TODO: Implement terraform testing

# tf-test:
# 	cd $(tf_tests) && \
# 		go test ${TEST_FILE} -v -timeout 30m -short