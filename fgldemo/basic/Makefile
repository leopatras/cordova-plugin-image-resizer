
#calling make without parameters simply creates an GMI executable for the simulator
#use "make gmi.install" to install on the simulator or device depending on the TARGET

BUNDLE_IDENTIFIER   = com.fourjs.cdvimageresizer
APPNAME             = CDVResize
DEVICE              = simulator
MODE                = debug
IDENTITY='(59W7RY75ZU)'
PROVISIONING_PROFILE=$(HOME)/Library/MobileDevice/Provisioning\ Profiles/fourjs_wildcard
VERBOSE=yes

# deduce the name from this repository
DIR_UP=$(shell dirname $(CURDIR)) 
PLUGINDIR=$(shell dirname $(DIR_UP))
PLUGIN=$(shell basename $(PLUGINDIR))

# the android part depends on code of cordova-plugin-camera
# thats why this plugin needs to be bundled too for GMA
# see ../../src/android/ImageResizer.java:
#   import org.apache.cordova.camera.FileHelper;
# you need to have checked out cordova-plugin-camera in a sibling
# directory of this plugin to make the GMA build working!


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
	gmibuildtool --install=$(1) --verbose=$(VERBOSE) --app-name=$(APPNAME) --bundle-id=$(BUNDLE_IDENTIFIER) --provisioning=$(PROVISIONING_PROFILE) --certificate=$(IDENTITY) --device=$(DEVICE) --mode=$(MODE) $(EXTENSION_LIBS) --build-cordova=../../../$(PLUGIN)
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


../../../cordova-plugin-camera:
	cd ../../.. && git clone https://github.com/leopatras/cordova-plugin-camera.git && cd -

gma.build: all ../../../cordova-plugin-camera
	rm -rf gma
	cd ../../.. && gmabuildtool scaffold --install-plugins ./cordova-plugin-camera,./$(PLUGIN) && cd -
	-gmabuildtool build --build-quietly --build-cordova cordova-plugin-camera,$(PLUGIN) --build-app-package-name $(BUNDLE_IDENTIFIER) 
#temporary hack for GMA-1467
	cp ./build.gradle gma/project/build.gradle
	gmabuildtool build --build-quietly --build-cordova cordova-plugin-camera,$(PLUGIN) --build-app-package-name $(BUNDLE_IDENTIFIER) 

gma.installsim: gma.build
	$$ANDROID_SDK_ROOT/platform-tools/adb install -r ./gma/project/app/build/app/outputs/apk/gma/app-unsigned.apk

clean::
	rm -f *.sch *.dbs *.42*
	rm -rf build bin distbin gma
	rm -f cordovamap.txt gmi/*.a gmi/link_flags.sh *.4pwvs *.4pwdb

distclean::clean
	rm -rf gmi.env resizer.xcodeproj/project.xcworkspace/ resizer.xcodeproj/xcuserdata/
