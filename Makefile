PREFIX = /usr/local
NOW = http://bscli.now.com

docs: bscli.1
	man ./$<

bscli.1: bscli.md
	curl -s -F page=@$< $(NOW) > $@

install:
	cp bscli.sh $(PREFIX)/bin/bscli
	cp bscli.1 $(PREFIX)/share/man/man1/bscli.1

uninstall:
	rm -f $(PREFIX)/bin/bscli
	rm -f bscli.1 $(PREFIX)/share/man/man1/bscli.1

.PHONY: docs install uninstall