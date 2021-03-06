#!/usr/bin/env bash
set -ev
cd $BUILD

### Now build pari

curl https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-$PARI_VERSION.tar.gz -o pari-$PARI_VERSION.tar.gz
tar xvf pari-$PARI_VERSION.tar.gz
cd pari-$PARI_VERSION

# --graphic=none since we obviously can't build X11 support.
time emconfigure ./Configure --host=wasm-emscripten --graphic=none --with-gmp-include=$PREFIX/include --with-gmp-lib=$PREFIX/lib

# We have to undefine UNIX because otherwise es.c tries to call getpwuid.
# This is because they don't detect that in Configure.  There is even
# a comment in es.c about this: "/* FIXME: HAS_GETPWUID */"
echo "#undef UNIX" >> Oemscripten-wasm/paricfg.h

cd Oemscripten-wasm

# Explanation of each of these:
#  - ERROR_ON_UNDEFINED_SYMBOLS=0  -- entirely because we do not have popen (no filesystem integration yet)
#  - the exported function and methods because those are what we use.
#  - initial memory: I just set the max value
#  - MODULARIZE=1: so we build a normal npm module that we can require in node.

time emmake make "CC_FLAVOR=-s ERROR_ON_UNDEFINED_SYMBOLS=0 -s EXPORTED_FUNCTIONS=[\'_gp_embedded\',\'_gp_embedded_init\',\'_pari_emscripten_plot_init\'] -s EXPORTED_RUNTIME_METHODS=[\'ccall\',\'cwrap\'] -s INITIAL_MEMORY=2146435072 -s MODULARIZE=1"

cp gp-sta* $BUILD/../dist/
