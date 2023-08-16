#!/bin/bash

package="bzip2"

set -xe

origin=$(pwd)
version=$(cd bzip2 && git describe --tags --abbrev=0)

install=$origin/lmod/dist/$(arch)/$package/$version
module=$origin/lmod/modules/$(arch)/$package/

mkdir -p $install
mkdir -p $module

NJ=${NJ:-$(nproc)}
# ===============

# Compile & install bzip2
rm -rf $install/*
cd $package

meson --prefix $install build/
ninja -C build
ninja -C build install
cd ..


# Setup the module file
cp $package.lua $module/$version.lua

sed -i -e "s@\${package}@$package@g" $module/$version.lua
sed -i -e "s@\${version}@$version@g" $module/$version.lua
