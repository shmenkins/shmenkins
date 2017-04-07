init:
	terraform init

zip:
	zip main.zip main.py

publish: zip init
	terraform apply

output:
	terraform output

destroy: init
	terraform destroy

clean:
	rm -f main.zip
