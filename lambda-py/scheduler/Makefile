# use current directory name as service name
service_name := $(shell basename $(shell dirname $(abspath $(firstword $(MAKEFILE_LIST)))))

-include Makefile.vars

init:
	cp Makefile.vars.template Makefile.vars && \
		${EDITOR} Makefile.vars

test:
	nosetests

zip: test clean
	zip -r $(service_name).zip main.py shmenkins --exclude \*.pyc

publish: zip
	aws s3 cp $(service_name).zip s3://$(bucket)/artifacts/$(service_name).zip

clean:
	rm -f $(service_name).zip
