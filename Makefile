# This is a very simple Makefile that calls 'gradlew' to do the heavy lifting.

default: archive

generate:
	make -j4 -C libmupdf generate
release: generate
	./gradlew assembleRelease
debug: generate
	./gradlew assembleDebug
lint:
	./gradlew lint
archive: generate
	./gradlew uploadArchives
sync: archive
	rsync -av $(HOME)/MAVEN/com/ ghostscript.com:/var/www/maven.ghostscript.com/com/

clean:
	rm -rf .cxx .externalNativeBuild .gradle build libmupdf/generated
