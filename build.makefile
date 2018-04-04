all:  docs vig build  check biocCheck

docs:
	R -e "devtools::document()"
vig:
	R -e "devtools::build_vignettes()"

build:
	(cd ..; R CMD build --no-build-vignettes RCyjs)

install:
	(R CMD INSTALL .)

check:
	(cd ..; R CMD check `ls -t RCyjs_* | head -1`)

biocCheck:
	(cd ..; R CMD BiocCheck `ls -t RCyjs_* | head -1`)
