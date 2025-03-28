#!/bin/bash

exec > /tmp/PostLogin.log 2>&1

if [ -s "${HOME}/.init.sh" ]; then
    su - ${USER} -c "${HOME}/.init.sh"
fi