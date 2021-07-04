#!/usr/bin/env bash
set -ev
export PARI_VERSION=2.13.2
export GMP_VERSION=6.2.1

export BUILD=`pwd`/build
export PREFIX=$BUILD/local
rm -rf $BUILD dist
mkdir $BUILD dist

./build-gmp.sh
./build-pari.sh