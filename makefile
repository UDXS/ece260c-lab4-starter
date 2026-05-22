start: OpenROAD/.e260clab4.installed

OpenROAD/README.md:
	@git clone https://github.com/The-OpenROAD-Project/OpenROAD.git
	

OpenROAD/.e260clab4.installed: OpenROAD/README.md
	@cp -f template.patch /temp.patch
	@cd OpenROAD && git submodule update --init --recursive && git reset --hard --recurse-submodules 52ff2a5ea5814dc671c1cf7c4b950f840b6a4e88
	@cd OpenROAD && ./etc/DependencyInstaller.sh -common && ./etc/Build.sh -cmake='-DLINK_TIME_OPTIMIZATION=OFF' 
	@cd OpenROAD && git apply --check --whitespace=nowarn /temp.patch  && git apply --whitespace=nowarn /temp.patch  || echo "Already applied"
	@touch OpenROAD/.e260clab4.installed
	@echo "Assignment Started."

.PHONY: open start build test_without_build test


open: start
	@code OpenROAD/src/dbSta/include/db_sta/ToySizer.hh
	@code OpenROAD/src/dbSta/src/ToySizer.cc

build:
	echo "Building..."
	cd OpenROAD/build && make --no-print-directory -j

test_without_build:
	@echo "Testing..."
	@mkdir -p results
	@rm -f results/*
	@OpenROAD/build/bin/openroad test.tcl

test: build test_without_build

turnin: test
	@echo "Turning in..."
	@cd OpenROAD && git add . 
	@cd OpenROAD && git diff --staged > /turnin.patch
	@cp -f /turnin.patch .
	@git add .
	@git commit -m "Turn-in"
	@git push

run: 
	@OpenROAD/build/bin/openroad