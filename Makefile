ANDROID_HOME := $(shell which adb | sed 's,/platform-tools/adb,,')

default: archive

generate:
	make -j4 -C libmupdf generate
assemble: generate
	ANDROID_HOME=$(ANDROID_HOME) ./gradlew assembleRelease
archive: generate
	ANDROID_HOME=$(ANDROID_HOME) ./gradlew uploadArchives
sync: archive
	rsync -av MAVEN/ ghostscript.com:public_html/maven/
clean:
	rm -rf .externalNativeBuild .gradle build
