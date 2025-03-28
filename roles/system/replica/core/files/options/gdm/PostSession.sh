#!/bin/sh

exec > /tmp/PostSession.log 2>&1

if [ "${USER}" = "guest" ]; then
    DATA_LOOPBACK=/var/lib/guest-session/mnt/data
    HOME_LOOPBACK=/var/lib/guest-session/mnt/home

    pkill -u ${USER} -9

    umount ${HOME} || umount -l ${HOME}
    umount ${HOME_LOOPBACK}/lower || umount -l ${HOME_LOOPBACK}/lower
    umount ${HOME_LOOPBACK} || umount -l ${HOME_LOOPBACK}
fi
