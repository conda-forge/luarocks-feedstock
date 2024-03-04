#!/usr/bin/env bash
set -x -e

# Debug: what is installed on the $BUILD_PREFIX with the current configuration?
ls -Rl $BUILD_PREFIX

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# TODO
# - Would be good if luarocks would offer the ability to use only a user rockspec, instead of system.
#   (Using system-only rockspec with --force-config flag installs packages with restrictive privileges)
./configure --prefix=$PREFIX \
    --sysconfdir=$PREFIX/share/lua/ \
    --with-lua-include=$PREFIX/include \
    --rocks-tree=$PREFIX

make bootstrap
