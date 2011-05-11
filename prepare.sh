#!/bin/bash

BUILDROOT_DIR="buildroot-2011.02"
BUILDROOT_FILE="$BUILDROOT_DIR.tar.gz"
BUILDROOT_URL="http://buildroot.uclibc.org/downloads/$BUILDROOT_FILE"

clean() {
    rm -Rf $BUILDROOT_FILE stella sdl
}

assert() {
    $@
    RET=$?
    if [ "$RET" != "0" ]; then
        echo "Error executing <$@> <Res=$RET>"
        clean
        exit 1
    fi
}

getBuildroot() {
    assert wget $BUILDROOT_URL
    assert tar zxfv $BUILDROOT_FILE
    assert rm -Rf $BUILDROOT_FILE
}

configBuildroot() {
    assert cp config_stella $BUILDROOT_DIR/.config
}

configKernel() {
    assert mkdir -p $BUILDROOT_DIR/dl
    assert cp -av linux-2.6.tar.bz2 $BUILDROOT_DIR/dl
}

configRootfs() {
    assert cp -av rootfs/* $BUILDROOT_DIR/fs/skeleton/
    assert cp -av rootfs/stella $BUILDROOT_DIR/fs/skeleton/root/
}

configPackages() {
    assert tar zxfv stella.tar.gz 
    assert cp -av stella $BUILDROOT_DIR/package/games
    assert tar zxfv sdl.tar.gz
    assert cp -av sdl $BUILDROOT_DIR/package
    assert sed -i 's/package\/games\/rubix\/Config.in/package\/games\/stella\/Config.in/' $BUILDROOT_DIR/package/Config.in
}

showMessage() {
    echo -e "\n********** BUILDROOT SUCCESSFULLY CONFIGURED! **********\n"
}

main() {
    clean
    getBuildroot
    configBuildroot
    configKernel
    configRootfs
    configPackages
    showMessage
    clean
}

main
