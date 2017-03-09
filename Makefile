# configures dev environment
config:
	# gradle.properties
	cfgen gradle.properties --overwrite
	ln -sf ../gradle.properties lambda/gradle.properties
	# terraform.tfvars
	cfgen terraform.tfvars --overwrite
	ln -sf ../../terraform.tfvars infra/repo_event_handler/terraform.tfvars

# reconfigures dev environment
reconfig:
	rm -f .cfgen.cache
	make configure


