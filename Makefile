.PHONY: all test clean

clean:
	- rm -rf docker-templates

autogen:
	- bash src/autogen.sh
