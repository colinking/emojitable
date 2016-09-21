.PHONY: install,download-mac,download-linux,install-emojicode,link,uninstall,clean,test

UNAME := $(shell uname)
# Linux
ifeq ($(UNAME), Linux)
install: clean download-linux install-emojicode link
	sudo apt-get install ttf-ancient-fonts
endif
# Mac OS X
ifeq ($(UNAME), Darwin)
install: clean download-mac install-emojicode link
endif

# Download a compiled binary of Emojicode for macOS machines
download-mac:
	mkdir -p tmp
	wget -O tmp/emojicode-sdk.tar.gz https://github.com/emojicode/emojicode/releases/download/v0.3-beta.2/Emojicode-0.3-beta.2-x86_64-apple-darwin15.6.0.tar.gz

# Download a compiled binary of Emojicode for Linux machines
download-linux:
	mkdir -p tmp
	wget -O tmp/emojicode-sdk.tar.gz https://github.com/emojicode/emojicode/releases/download/v0.3-beta.2/Emojicode-0.3-beta.2-x86_64-linux-gnu.tar.gz

# Installs Emojicode from a downloaded tarball
install-emojicode:
	mkdir tmp/emojicode-sdk
	tar -xzf tmp/emojicode-sdk.tar.gz -C tmp/emojicode-sdk  --strip-components 1
	cd tmp/emojicode-sdk && sudo ./install.sh

# Create a link to the source files in this directory within the Emojicode Package Search Path
# See: http://www.emojicode.org/docs/reference/packages.html
link: uninstall
	ln -s "$(realpath emojitable-v0)" /usr/local/EmojicodePackages/emojitable

# Uninstalls the emojitable package
uninstall:
	rm -f /usr/local/EmojicodePackages/emojitable

# Removes temporary files, created from installing Emojicode
clean:
	rm -rf ./tmp

# Runs tests for the emojitable package
test:
	@ emojicodec tests/emojitable-test.emojic
	@ emojicode tests/emojitable-test.emojib

# Runs a stress test for the emojitable package
stress-test:
	@ emojicodec tests/emojitable-stresstest.emojic
	@ time emojicode tests/emojitable-stresstest.emojib
