
#calling make without parameters simply creates an GMI executable for the simulator
#use "make gmi.install" to install on the simulator or device depending on the TARGET

BUNDLE_IDENTIFIER   = com.4js.resizerdemo
APPNAME             = CDVResize
DEVICE              = simulator
MODE                = debug
IDENTITY='(59W7RY75ZU)'
PROVISIONING_PROFILE=/Users/leo/Library/MobileDevice/Provisioning\ Profiles/4js_wildcard
VERBOSE=yes

PLUGIN=../..
# in case you build the demo when having the plugin checked out of github 
# then we use the native code from this repository

MODULES  = $(patsubst %.4gl, %.42m, $(wildcard *.4gl))
FORMS    = $(patsubst %.per, %.42f, $(wildcard *.per))

%.42m: %.4gl
	fglcomp -M $*

%.42f: %.per
	fglform -M $*

all:: $(MODULES) $(FORMS)


run: main.42m
	FGLLDPATH=$(FGLLDPATH) fglrun main

define gmibuild
	gmibuildtool --install=$(1) --verbose=$(VERBOSE) --app-name=$(APPNAME) --bundle-id=$(BUNDLE_IDENTIFIER) --provisioning=$(PROVISIONING_PROFILE) --certificate=$(IDENTITY) --device=$(DEVICE) --mode=$(MODE) $(EXTENSION_LIBS) --build-cordova=$(PLUGIN)
endef

gmi.build: all 
	$(call gmibuild,no)

gmi.install: all 
	$(call gmibuild,yes)

openxcode:
	@rm -f gmi.env
ifdef GMIDIR
	echo "export GMIDIR=$(GMIDIR)" > gmi.env
endif
ifdef FGLDIR
	echo "export FGLDIR=$(FGLDIR)" >> gmi.env
else
	$(error FGLDIR must be set)
endif
	open resizer.xcodeproj

clean::
	rm -f *.sch *.dbs *.42*
	rm -rf build bin distbin 
	rm -f cordovamap.txt gmi/*.a gmi/link_flags.sh *.4pwvs *.4pwdb

distclean::clean
	rm -rf gmi.env resizer.xcodeproj/project.xcworkspace/ resizer.xcodeproj/xcuserdata/
