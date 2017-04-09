zip := "builder.zip"

include Makefile.vars

test:
	nosetests

zip: test clean
	zip -r $(zip) shmenkins --exclude \*.pyc

publish: zip
	aws s3 cp $(zip) s3://$(bucket)/artifacts/$(zip)

clean:
	rm -f $(zip)
