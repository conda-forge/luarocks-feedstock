#!/usr/bin/env bash
set -x -e

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

# Ensure to remove all traces of the build directory from distributed scripts,
# if we are cross compiling the package
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
    for binfile in $PREFIX/bin/*; do
        if [[ -f "${binfile}" && ! "$(file --mime-type --brief -- ${binfile})" =~ ^text$ ]]
        then
            sed -i '' "s,${BUILD_PREFIX},${PREFIX},g" "${binfile}"
        fi
    done
fi
