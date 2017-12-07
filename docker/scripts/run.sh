#!/bin/sh

docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /var/lib/dbus:/var/lib/dbus -v ~/.pulse:/root/.pulse -v /dev/shm:/dev/shm \
    -v /etc/machine-id:/etc/machine-id \
    -v /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
    --device /dev/dri:/dev/dri \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/snd \
    --group-add $(getent group audio | cut -d: -f3) \
    -v ${HOME}/.local/share/dolphin-emu/Games:/home/developer/.local/share/dolphin-emu/Games \
    smashbot $@
