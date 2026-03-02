#!/bin/sh

DEP="$1"
SRC="$2"
TGT="$3"
cp -v "$SRC" "$TGT"
gftools gen-stat --src "$DEP" --inplace "$TGT"
