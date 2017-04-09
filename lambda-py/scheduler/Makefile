zip := "scheduler.zip"

-include Makefile.vars

init:
	cp Makefile.vars.template Makefile.vars && \
		${EDITOR} Makefile.vars

test:
	nosetests

zip: test clean
	zip -r $(zip) main.py shmenkins --exclude \*.pyc

publish: zip
	aws s3 cp $(zip) s3://$(bucket)/artifacts/$(zip)

clean:
	rm -f $(zip)
