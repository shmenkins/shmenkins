# configures dev environment
config:
	# gradle.properties
	rm -f gradle.properties
	cfgen gradle.properties
	ln -sf ../gradle.properties lambda/gradle.properties
	# terraform.tfvars
	rm -f terraform.tfvars
	cfgen terraform.tfvars
	ln -sf ../../terraform.tfvars infra/repo_event_handler/terraform.tfvars

# reconfigures dev environment
reconfig:
	rm -f .cfgen.cache
	make configure


