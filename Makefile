PACKAGE = package
DOCCMD = lua external/ldoc/ldoc.lua src

# From http://scribu.net/blog/git-alias-for-updating-submodules.html
GIT_FETCHALL = git submodule foreach git fetch origin --tags && git pull && git submodule update --init --recursive

# target: all - Default target. Calls init, clean and dist
all:	init docs

# target: help - Shows available targets
help:
	egrep "^# target:" [Mm]akefile

# target: init - Initializes the development environment
init:
	$(GIT_FETCHALL)						\

# target: run - Runs game in debug mode (updates submodules if needed)
run:	init
	love src

# target: fastrun - Runs game in debug mode without updating submodules
fastrun:
	love src

#target: docs - Rebuilds documentation
docs:	init
	$(DOCCMD)	

#target: watch - Watches src folder and rebuilds documentation on change
watch:	init
	iwatch -e close_write -c "$(DOCCMD)" -X "[~#]." -r src

.PHONY: all help init run fastrun docs watch
