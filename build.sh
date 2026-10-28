#!/bin/sh
# Compiles src/*.adb to WebAssembly (GNAT-LLVM / AdaWebPack) and embeds it,
# together with the GNATprove summary from proof/gnatprove.out, into
# docs/index.html (served by GitHub Pages).
set -e
cd "$(dirname "$0")"
T=$PWD/toolchain/usr
[ -x "$T/bin/llvm-gcc" ] || { echo "Run tools/get-toolchain.sh first"; exit 1; }
[ -f proof/gnatprove.out ] || { echo "Run ./prove.sh first"; exit 1; }
export LD_LIBRARY_PATH="$PWD/toolchain/lib"
LD=$(command -v wasm-ld || ls /usr/bin/wasm-ld-* | tail -1)
rm -rf obj/wasm && mkdir -p obj/wasm docs
cd obj/wasm
# -gnatp: run-time checks are not compiled in, because GNATprove proved
# every one of them (Silver, see proof/gnatprove.out); a check that cannot
# fail costs time in the browser for nothing.
for F in ../../src/*.adb; do
  "$T/bin/llvm-gcc" -c --target=wasm32 -O2 -gnat2012 -gnatp -gnatwa -gnatwe \
    --RTS="$T/lib/rts-native" -I../../src "$F"
done
ar x "$T/lib/rts-native/adalib/libgnat.a" s-memcop.o s-memmov.o s-memset.o
"$LD" --no-entry --strip-all --export=mf_set_param --export=mf_start \
  --export=mf_tick --export=mf_count --export=mf_x --export=mf_y \
  --export=mf_vx --export=mf_vy --initial-memory=16777216 -o mf.wasm *.o
cd ../..
python3 tools/embed.py obj/wasm/mf.wasm proof/gnatprove.out web/template.html docs/index.html
echo "Built docs/index.html ($(wc -c < obj/wasm/mf.wasm) bytes of WebAssembly)"
