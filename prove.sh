#!/bin/sh
# Runs GNATprove on the whole SPARK core and keeps the summary in
# proof/gnatprove.out (committed, and shown by the live page).
set -e
cd "$(dirname "$0")"
gnatprove -P murmuration.gpr -j0 --mode=all --level=2 --timeout=60 --report=fail \
  --checks-as-errors=on
mkdir -p proof
cp obj/gnatprove/gnatprove.out proof/gnatprove.out
gnatprove --version | head -1 > proof/version.txt
