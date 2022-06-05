# This is a very simple Makefile that calls 'gradlew' to do the heavy lifting.

default: archive

release:
	./gradlew --warning-mode=all assembleRelease
debug:
	./gradlew --warning-mode=all assembleDebug
lint:
	./gradlew --warning-mode=all lint
archive:
	./gradlew --warning-mode=all publishReleasePublicationToLocalRepository
sync: archive
	rsync -av --chmod=g+w --chown=:gs-priv $(HOME)/MAVEN/com/ ghostscript.com:/var/www/maven.ghostscript.com/com/

clean:
	rm -rf .cxx .externalNativeBuild .gradle build
