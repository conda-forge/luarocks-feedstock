#!/usr/bin/env bash
set -x -e

# See what is set
# env | sort

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# TODO
# - Would be good if luarocks would offer the ability to use only a user rockspec, instead of system.
#   (Using system-only rockspec with --force-config flag installs packages with restrictive privileges)
if [[ "$variant" == "luajit" ]]; then
    ./configure --prefix=$PREFIX \
        --sysconfdir=$PREFIX/share/lua/ \
        --with-lua-include=$(realpath $PREFIX/include/luajit-*) \
        --rocks-tree=$PREFIX
else
    ./configure --prefix=$PREFIX \
        --sysconfdir=$PREFIX/share/lua/ \
        --with-lua-include=$PREFIX/include \
        --rocks-tree=$PREFIX
fi

make bootstrap

# Ensure to remove all traces of the build directory from distributed scripts,
# if we are cross compiling the package
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
    for binfile in $PREFIX/bin/luarocks{,-admin}; do
        sed -i'' "s,${BUILD_PREFIX},${PREFIX},g" "${binfile}"
    done
fi
