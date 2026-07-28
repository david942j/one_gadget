#!/bin/sh
# Build the park_stub helper for each architecture Aletheia can drive on this
# host. The native stub always builds; a cross stub builds only when its
# cross-compiler is installed. Binaries are host-specific build artifacts (see
# .gitignore), so run this once after checkout / after editing park_stub.c.
#
#   ./build_stubs.sh
set -eu
cd "$(dirname "$0")"

build() {
  cc="$1" out="$2"
  if command -v "$cc" >/dev/null 2>&1; then
    "$cc" -O0 -g -o "$out" park_stub.c -ldl
    echo "built $out (via $cc)"
  else
    echo "skip  $out ($cc not installed)"
  fi
}

# Native host arch.
case "$(uname -m)" in
  aarch64) build cc park_stub_aarch64 ;;
  x86_64)  build cc park_stub_x86_64 ;;
  *) echo "unknown host arch $(uname -m); build a stub manually" >&2 ;;
esac

# Cross stubs for foreign targets driven under qemu-user.
[ "$(uname -m)" = aarch64 ] && build x86_64-linux-gnu-gcc park_stub_x86_64
[ "$(uname -m)" = x86_64 ]  && build aarch64-linux-gnu-gcc park_stub_aarch64
build i686-linux-gnu-gcc park_stub_i386 # i386 (32-bit) is always cross-built
exit 0
