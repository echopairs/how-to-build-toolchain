#!/bin/bash
#-------------------------------------
# Filename: build.sh
# Revision: 1.0
# Data: 2017/02/28
# Des:  build release deb && debuginfo.deb
# author: pairs
# email:736418319@qq.com
# env Ubuntu
#------------------------------------

script=$(readlink -f "$0")
route=$(dirname "$script")

VERSION=`cat ${route}/../version`

# 1. gen release target, TODO
if [ -d "$route/../build" ]; then
    rm -rf $route/../build
fi

if [ -d "$route/../deb" ]; then
    rm -rf $route/../deb
fi

mkdir -p $route/../build || exit 1
mkdir -p $route/../deb || exit 2

cd $route/../build
cmake .. -G "Unix Makefiles"
make -j 4 || exit 3

# 2. strip release
sh ${route}/strip.sh || exit 4


# 3. gen release deb
cd $route/../build
sudo checkinstall -D --install=no --default --pkgname=jrpc --pkgversion=${VERSION} --pakdir=${route}/../deb --fstrans=no || exit 5


# 4. gen debug deb
cp ${route}/Makefile.debuginfo   ${route}/../release/Makefile || exit 6
cd ${route}/../release/
sudo checkinstall -D --install=no --default --pkgname=jrpc-debuginfo --pkgversion=${VERSION} --pakdir=${route}/../deb --fstrans=no || exit 7
