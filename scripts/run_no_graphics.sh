#!/bin/bash

docker run -ti --rm \
    -v /var/lib/dbus:/var/lib/dbus -v ~/.pulse:/root/.pulse -v /dev/shm:/dev/shm \
    -v /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
    --device /dev/snd \
    --group-add $(getent group audio | cut -d: -f3) \
    -v ${HOME}/.local/share/dolphin-emu/Games:/home/developer/.local/share/dolphin-emu/Games \
    smashbot $@
