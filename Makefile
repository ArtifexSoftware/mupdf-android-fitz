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
	rsync -av --chmod=g+w --chown=:gs-web \
		$(HOME)/MAVEN/com/artifex/mupdf/fitz/$(shell git describe --tags)/ \
		ghostscript.com:/var/www/maven.ghostscript.com/com/artifex/mupdf/fitz/$(shell git describe --tags)/
	rsync -av --chmod=g+w --chown=:gs-web \
		$(HOME)/MAVEN/com/artifex/mupdf/fitz/maven-metadata.xml* \
		ghostscript.com:/var/www/maven.ghostscript.com/com/artifex/mupdf/fitz/

tarball: release
	test -d build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib
	test -f build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/x86_64/libmupdf_java.so
	test -f build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/x86/libmupdf_java.so
	test -f build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/arm64-v8a/libmupdf_java.so
	test -f build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/armeabi-v7a/libmupdf_java.so
	cd build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib; \
		zip -q -r ../../../../../../../fitz-symbols-$(shell git describe --tags).zip *
synctarball: tarball
	rsync -av --chmod=g+w --chown=:gs-web \
		fitz-symbols-$(shell git describe --tags).zip \
		ghostscript.com:/var/www/mupdf.com/downloads/archive/fitz-symbols-$(shell git describe --tags).zip

clean:
	rm -rf .cxx .externalNativeBuild .gradle build
