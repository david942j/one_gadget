#!/bin/sh
# Build a per-version sysroot + park_stub for a foreign libc whose version differs
# too much from the host cross toolchain to dlopen directly (an older libc's init
# crashes under a newer ld.so; the stub also needs that libc's older symbols).
#
# Fetches the matching libc6 + libc6-dev .debs (the fixtures come from ubuntu),
# extracts them into sysroots/<arch>-<major.minor>/, and cross-builds park_stub
# against that libc so it only references its (older) symbol versions. The
# transport auto-uses sysroots/<arch>-<major.minor>/ when it exists (matched on
# the fixture's glibc version); otherwise the arch's default cross sysroot is used.
#
#   ./build_sysroot.sh i386 2.27-3ubuntu1
set -eu
cd "$(dirname "$0")"

arch="${1:?usage: build_sysroot.sh <i386> <ubuntu-libc6-version>}"
ver="${2:?usage: build_sysroot.sh <i386> <ubuntu-libc6-version>}"
short=$(echo "$ver" | grep -oE '^[0-9]+\.[0-9]+')

case "$arch" in
  i386) deb_arch=i386; cc=i686-linux-gnu-gcc; ldso=ld-linux.so.2; dl=-l:libdl.so.2 ;;
  *) echo "unsupported arch $arch" >&2; exit 2 ;;
esac

root="sysroots/$arch-$short"
rm -rf "$root"; mkdir -p "$root"
base='https://launchpad.net/ubuntu/+archive/primary/+files'
tmp=$(mktemp -d)
for pkg in libc6 libc6-dev; do
  f="${pkg}_${ver}_${deb_arch}.deb"
  echo "fetch $f"
  curl -sfL --max-time 120 -o "$tmp/$f" "$base/$f"
  dpkg-deb -x "$tmp/$f" "$root"
done
rm -rf "$tmp"

# qemu resolves the stub's interpreter (/lib/$ldso) against QEMU_LD_PREFIX=$root.
[ -e "$root/lib/$ldso" ] || ln -sf "$deb_arch-linux-gnu/$ldso" "$root/lib/$ldso"

libdir="$root/usr/lib/$deb_arch-linux-gnu"
# -nostdinc: use ONLY the sysroot's headers (plus gcc's own builtins), so an old
# features.h isn't paired with the toolchain's newer sys/cdefs.h.
gcc_inc=$("$cc" -print-file-name=include)
"$cc" --sysroot="$root" -B"$libdir" -L"$libdir" -L"$root/lib/$deb_arch-linux-gnu" \
  -nostdinc -isystem "$gcc_inc" -isystem "$root/usr/include" \
  -isystem "$root/usr/include/$deb_arch-linux-gnu" \
  -O0 -g park_stub.c -o "$root/park_stub" \
  -Wl,-Bdynamic,-rpath-link,"$root/lib/$deb_arch-linux-gnu" $dl
echo "built $root (glibc $short) + park_stub"
