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
  i386)    deb_arch=i386;  triplet=i386-linux-gnu;      cc=i686-linux-gnu-gcc;      ldso=ld-linux.so.2 ;;
  arm)     deb_arch=armhf; triplet=arm-linux-gnueabihf; cc=arm-linux-gnueabihf-gcc; ldso=ld-linux-armhf.so.3 ;;
  aarch64) deb_arch=arm64; triplet=aarch64-linux-gnu;   cc=aarch64-linux-gnu-gcc;   ldso=ld-linux-aarch64.so.1 ;;
  amd64)   deb_arch=amd64; triplet=x86_64-linux-gnu;    cc=x86_64-linux-gnu-gcc;    ldso=ld-linux-x86-64.so.2 ;;
  *) echo "unsupported arch $arch" >&2; exit 2 ;;
esac
dl=-l:libdl.so.2

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

# Normalise split-usr vs merged-usr layouts so both /lib/$triplet and
# /usr/lib/$triplet resolve to the runtime libs no matter which the .deb used.
# A native arch's ld.so (running under qemu on a host of the same arch) may probe
# /usr/lib/$triplet before /lib/$triplet, while the target's baked interpreter
# path is /lib/$ldso -- both must land inside the sysroot or qemu falls back to
# the HOST's newer libc and the versions clash.
if [ -d "$root/lib/$triplet" ]; then
  # Split-usr (older debs): libs in /lib; mirror them under /usr/lib.
  mkdir -p "$root/usr/lib/$triplet"
  for so in "$root/lib/$triplet"/*.so*; do
    [ -e "$so" ] && ln -sf "../../../lib/$triplet/$(basename "$so")" \
                          "$root/usr/lib/$triplet/$(basename "$so")"
  done
else
  # Merged-usr (newer debs, e.g. glibc >= ~2.36): libs live only in /usr/lib;
  # point /lib at it (as a real merged-usr root does) so /lib paths resolve too.
  ln -sfn usr/lib "$root/lib"
fi

# qemu resolves the stub's interpreter (its own PT_INTERP path) against
# QEMU_LD_PREFIX=$root. The conventional path is /lib/$ldso, but amd64 .debs use
# /lib64/$ldso, and a fixture built by a nonstandard toolchain/prefix has been
# seen using /usr/lib/$ldso directly (no triplet dir) -- symlink all three; they're
# cheap, and only the one path a given target's PT_INTERP actually names matters.
mkdir -p "$root/usr/lib"
[ -e "$root/usr/lib/$ldso" ] || ln -sf "$triplet/$ldso" "$root/usr/lib/$ldso"

# /lib and /lib64 as alternate interpreter locations: skip /lib when it's
# already the merged-usr symlink to usr/lib (from the layout step above) --
# usr/lib/$ldso just above already covers /lib/$ldso transparently through it,
# and a *fresh* real symlink here, one level short, would point at the wrong
# place (relative to where it actually lands once the kernel follows /lib).
if [ ! -L "$root/lib" ]; then
  mkdir -p "$root/lib"
  [ -e "$root/lib/$ldso" ] || ln -sf "../usr/lib/$triplet/$ldso" "$root/lib/$ldso"
fi
mkdir -p "$root/lib64"
[ -e "$root/lib64/$ldso" ] || ln -sf "../usr/lib/$triplet/$ldso" "$root/lib64/$ldso"

libdir="$root/usr/lib/$triplet"
# -nostdinc: use ONLY the sysroot's headers (plus gcc's own builtins), so an old
# features.h isn't paired with the toolchain's newer sys/cdefs.h.
gcc_inc=$("$cc" -print-file-name=include)
"$cc" --sysroot="$root" -B"$libdir" -L"$libdir" -L"$root/lib/$triplet" \
  -nostdinc -isystem "$gcc_inc" -isystem "$root/usr/include" \
  -isystem "$root/usr/include/$triplet" \
  -O0 -g park_stub.c -o "$root/park_stub" \
  -Wl,-Bdynamic,-rpath-link,"$root/lib/$triplet" $dl

# A second, natively-invokable copy. The park_stub above keeps a generic
# interpreter path that qemu-user redirects into this sysroot via
# QEMU_LD_PREFIX; a real (non-qemu) execve has no such redirection, so on a
# host whose own arch matches this sysroot's, dlopen-ing the target libc
# through the HOST's ld.so hits glibc-private, version-sensitive symbols
# (_dl_exception_create and friends) -- the exact mismatch this sysroot exists
# to avoid. This copy instead embeds the sysroot's OWN ld.so as its
# interpreter and a matching runtime rpath, so the kernel loads it directly
# with no redirection needed (see Transport::Native).
abs_root=$(cd "$root" && pwd)
"$cc" --sysroot="$root" -B"$libdir" -L"$libdir" -L"$root/lib/$triplet" \
  -nostdinc -isystem "$gcc_inc" -isystem "$root/usr/include" \
  -isystem "$root/usr/include/$triplet" \
  -O0 -g park_stub.c -o "$root/park_stub_native" \
  -Wl,-Bdynamic,--dynamic-linker,"$abs_root/lib/$ldso" \
  -Wl,-rpath,"$abs_root/lib/$triplet:$abs_root/usr/lib/$triplet" $dl

echo "built $root (glibc $short) + park_stub + park_stub_native"
