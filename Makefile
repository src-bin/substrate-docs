all:
	mkdir -p www
	find -type d -printf %P\\n | grep -v ^.git | grep -v ^www | xargs -I_ mkdir -p www/_
	find -name \*.md -type f -printf %P\\n | grep -v ^.git | grep -v ^www | while read P; do mergician -o www/$${P%.md}.html $$P; done
	find -not -name \*.md -type f -printf %P\\n | grep -v ^.git | grep -v ^www | xargs -I_ cp _ www/_
	mv www/README.html www/index.html

clean:
	rm -f -r www
	find -name \*.html -delete
	find -name .\*.html.sha256 -delete

install:
	TODO aws s3 sync

.PHONY: all clean install
