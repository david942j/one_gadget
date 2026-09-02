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
  riscv64) build cc park_stub_riscv64 ;;
  *) echo "unknown host arch $(uname -m); build a stub manually" >&2 ;;
esac

# Cross stubs for foreign targets driven under qemu-user.
[ "$(uname -m)" = aarch64 ] && build x86_64-linux-gnu-gcc park_stub_x86_64
[ "$(uname -m)" = x86_64 ]  && build aarch64-linux-gnu-gcc park_stub_aarch64
build i686-linux-gnu-gcc park_stub_i386 # i386 (32-bit) is always cross-built
build arm-linux-gnueabihf-gcc park_stub_arm # armhf (32-bit) is always cross-built
build riscv64-linux-gnu-gcc park_stub_riscv64 # cross-built unless the host is riscv64 itself

# MIPS has no cross-compiler to install -- the distribution dropped the
# architecture -- so clang, which targets it natively, builds against a sysroot
# fetched from Debian's own mipsel packages. The stub must be *glibc*: a musl
# stub cannot dlopen a musl target, because musl refuses to load a second copy of
# itself. -z execstack is needed because Debian's MIPS crt objects carry no
# GNU_STACK marker, which lld otherwise rejects.
build_mipsel() {
  out=park_stub_mipsel sys=sysroots/mipsel
  if ! command -v clang >/dev/null 2>&1; then
    echo "skip  $out (clang not installed)"
    return 0
  fi
  if [ ! -f "$sys/lib/mipsel-linux-gnu/libc.so.6" ]; then
    echo "fetching the mipsel sysroot into $sys ..."
    mkdir -p "$sys" || return 0
    base=http://ftp.debian.org/debian/pool/main
    for url in "$base/g/glibc/libc6_2.36-9+deb12u14_mipsel.deb" \
               "$base/g/glibc/libc6-dev_2.36-9+deb12u14_mipsel.deb" \
               "$base/g/gcc-12/libgcc-12-dev_12.2.0-14+deb12u1_mipsel.deb" \
               "$base/g/gcc-12/libgcc-s1_12.2.0-14+deb12u1_mipsel.deb"; do
      ( cd "$sys" && curl -fsSLO "$url" && ar x "$(basename "$url")" && tar -xf data.tar.* ) || {
        echo "skip  $out (could not fetch $url)"; return 0; }
    done
  fi
  gcc_lib="$sys/usr/lib/gcc/mipsel-linux-gnu/12"
  clang --target=mipsel-linux-gnu -fuse-ld=lld --sysroot="$sys" \
        -B"$gcc_lib" -L"$gcc_lib" -L"$sys/lib/mipsel-linux-gnu" -Wl,-z,execstack \
        -O0 -g -o "$out" park_stub.c -ldl && echo "built $out (via clang + $sys)"
}
build_mipsel

# A musl fixture cannot be loaded beside the stub -- musl refuses to load a
# second copy of itself -- so it is run AS the stub's own libc, which means a
# stub built against musl, one per byte order. OpenWrt's toolchain supplies both
# the headers and the loader name to link against.
build_musl() {
  arch="$1" target="$2" tgt_dir="$3" out="park_stub_${4}_musl"
  if ! command -v clang >/dev/null 2>&1; then
    echo "skip  $out (clang not installed)"
    return 0
  fi
  tc=$(find sysroots -maxdepth 3 -type d -name "toolchain-${arch}_gcc-*_musl" 2>/dev/null | head -1)
  if [ -z "$tc" ]; then
    echo "fetching the $arch musl toolchain ..."
    mkdir -p sysroots
    url="https://downloads.openwrt.org/releases/23.05.5/targets/$tgt_dir/openwrt-toolchain-23.05.5-$(echo "$tgt_dir" | tr / -)_gcc-12.3.0_musl.Linux-x86_64.tar.xz"
    ( cd sysroots && curl -fsSLO "$url" && tar -xf "$(basename "$url")" ) || {
      echo "skip  $out (could not fetch $url)"; return 0; }
    tc=$(find sysroots -maxdepth 3 -type d -name "toolchain-${arch}_gcc-*_musl" | head -1)
  fi
  gcc_lib=$(dirname "$(find "$tc" -name libgcc.a | head -1)")
  loader=$(basename "$(find "$tc/lib" -name 'ld-musl-*.so.1' | head -1)")
  clang --target="$target" -msoft-float -fuse-ld=lld --sysroot="$tc" \
        -B"$gcc_lib" -L"$gcc_lib" -Wl,--dynamic-linker="/lib/$loader" \
        -O0 -g -o "$out" park_stub.c && echo "built $out (via clang + $tc)"
}
build_musl mipsel_24kc mipsel-linux-musl ramips/mt7621 mipsel
build_musl mips_24kc   mips-linux-musl   ath79/generic  mips
exit 0
