all-configs:
	make gradle.properties
	make terraform.tfvars

# terraform shortcuts

terraform.tfvars:
	cfgen terraform.tfvars --overwrite
	ln -sf ../../terraform.tfvars infra/repo_event_handler/terraform.tfvars

tfplan:
	cd infra/repo_event_handler && terraform plan

tfapply:
	cd infra/repo_event_handler && terraform apply

# gradle shortcuts

gradle.properties:
	cfgen gradle.properties --overwrite
	ln -sf ../gradle.properties lambda/gradle.properties

WebhookLambda:
	cd lambda && ./gradlew :$@:publish

BuildSchedulerLambda:
	cd lambda && ./gradlew :$@:publish

BuilderLambda:
	cd lambda && ./gradlew :$@:publish

lambda:
	cd lambda && ./gradlew publish
