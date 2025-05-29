/OpenROAD/.e260clab4.installed:
	@cp -f template.patch /temp.patch
	@cd /OpenROAD && git apply --whitespace=nowarn /temp.patch 
	@touch /OpenROAD/.e260clab4.installed
	@echo "Assignment Started."

.PHONY: open start build test_without_build test

start: /OpenROAD/.e260clab4.installed

open: start
	@code -a /OpenROAD/src/dbSta
	@code -a /OpenROAD/src/sta
	@code /OpenROAD/src/dbSta/include/db_sta/ToySizer.hh
	@code /OpenROAD/src/dbSta/src/ToySizer.cc b/src/dbSta/src/ToySizer.cc

build:
	echo "Building..."
	cd /OpenROAD/build && make --no-print-directory -j

test_without_build:
	@echo "Testing..."
	@mkdir -p results
	@rm -f results/*
	/OpenROAD/build/src/openroad test.tcl

test: build test_without_build

turnin: test
	@echo "Turning in..."
	@cd /OpenROAD && git add . 
	@cd /OpenROAD && git diff --staged > /turnin.patch
	@cp -f /turnin.patch .
	@git add .
	@git commit -m "Turn-in"
	@git push

run: 
	/OpenROAD/build/src/openroad