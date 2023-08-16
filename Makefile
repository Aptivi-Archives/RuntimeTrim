#!/usr/bin/make -f
#
# MIT License
#
# Copyright (c) 2023 Aptivi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

OUTPUTS = RuntimeTrim*/bin RuntimeTrim*/obj debian/runtimetrim
OUTPUT = RuntimeTrim/bin/Release/net6.0
BINARIES = debian/runtime-trim
MANUALS = doc/runtime-trim.1

.PHONY: all debian-install

# General use

all: all-online

all-online:
	$(MAKE) -C tools invoke-build

# Below targets are for Debian packaging only

debian-all-offline:
	$(MAKE) -C tools invoke-build-offline

debian-init-offline:
	$(MAKE) -C tools debian-invoke-init-offline

debian-install:
	mkdir -m 755 -p debian/runtimetrim/usr/bin debian/runtimetrim/usr/lib/runtimetrim
	install -m 755 -t debian/runtimetrim/usr/bin/ $(BINARIES)
	install -m 755 -t debian/ $(MANUALS)
	find $(OUTPUT) -mindepth 1 -type d -exec sh -c 'mkdir -p -m 755 "debian/runtimetrim/usr/lib/runtimetrim/$$(realpath --relative-to $(OUTPUT) "$$0")"' {} \;
	find $(OUTPUT) -mindepth 1 -type f -exec sh -c 'install -m 644 -t "debian/runtimetrim/usr/lib/runtimetrim/$$(dirname $$(realpath --relative-to $(OUTPUT) "$$0"))" "$$0"' {} \;

clean:
	rm -rf $(OUTPUTS)

# This makefile is just a wrapper for tools scripts.
