#!/bin/sh

exec > /tmp/PostLogin.log 2>&1

if [ "${USER}" = "guest" ]; then
    DATA_LOOPBACK=/var/lib/guest-session/mnt/data
    HOME_LOOPBACK=/var/lib/guest-session/mnt/home

    mount -o loop /var/lib/guest-session/data.img ${DATA_LOOPBACK} || exit 1
    mount -o loop /var/lib/guest-session/home.img ${HOME_LOOPBACK} || {
        umount ${DATA_LOOPBACK}
        exit 1
    }

    rm -rf ${HOME_LOOPBACK}/lower ${HOME_LOOPBACK}/upper ${HOME_LOOPBACK}/work

    mkdir ${HOME_LOOPBACK}/lower ${HOME_LOOPBACK}/upper ${HOME_LOOPBACK}/work
    chown ${USER}:${USER} ${HOME_LOOPBACK}/upper ${HOME_LOOPBACK}/work

    chown ${USER}:${USER} ${DATA_LOOPBACK}

    bindfs -r --map=0/1000:@0/@1000 /etc/guest-session/skel ${HOME_LOOPBACK}/lower || {
        umount ${HOME_LOOPBACK}
        umount ${DATA_LOOPBACK}
        exit 1
    }

    mount -t overlay -o lowerdir=${HOME_LOOPBACK}/lower,upperdir=${HOME_LOOPBACK}/upper,workdir=${HOME_LOOPBACK}/work overlay ${HOME} || {
        umount ${HOME_LOOPBACK}/lower
        umount ${HOME_LOOPBACK}
        umount ${DATA_LOOPBACK}
        exit 1
    }

    ln -s -f ${DATA_LOOPBACK} "${HOME}/Área compartilhada"
fi

if [ -s "${HOME}/.init.sh" ]; then
    su - ${USER} -c "${HOME}/.init.sh"
fi
