all-configs:
	make gradle.properties
	make terraform.tfvars

gradle.properties:
	cfgen gradle.properties --overwrite
	ln -sf ../gradle.properties lambda/gradle.properties

terraform.tfvars:
	cfgen terraform.tfvars --overwrite
	ln -sf ../../terraform.tfvars infra/repo_event_handler/terraform.tfvars

