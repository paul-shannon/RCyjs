build: webpack assemble buildPackage installPackage

assemble:
	(cd ./dist; m4 -P rcyjs.html-template | sed s/\`//g > rcyjs.html)
	ls -l ./dist/rcyjs.html

buildPackage:
	(cd ../../..; R CMD build --no-build-vignettes rcyjs)

installPackage:
	(cd ../../..; R CMD INSTALL `ls -at RCyjs_* | head -1`)

webpack:
	npm update
	webpack

test:
	(cd ./dist; pwd)

all: clean install run

clean:
	- rm -rf dist/
	- rm -rf node_modules

install:
	npm install
