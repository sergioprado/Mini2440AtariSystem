#!/bin/sh
DIR="/mnt/sdcard"

if [ ! -e $DIR ]; then
    mkdir -p $DIR
fi

mountSD() {
    mount $MDEV $DIR
}

umountSD() {
    umount $MDEV
}

case "$ACTION" in

    "add"|"")
        umountSD
        mountSD
    ;;

    "remove")
        umountSD
    ;;

esac
