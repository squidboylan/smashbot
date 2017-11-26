#!/bin/bash -xe

git clone https://github.com/squidboylan/libdolphin.git /home/developer/libdolphin

virtualenv /home/developer/venv -p /usr/bin/python3 && \
    /home/developer/venv/bin/pip install -r \
    /home/developer/libdolphin/requirements.txt && \
    /home/developer/venv/bin/pip install -e /home/developer/libdolphin

if [ -z "$DISPLAY" ] ; then
    Xvfb :19 -screen 0 640x528x16 &
    export DISPLAY=:19
fi

/home/developer/venv/bin/python3 /home/developer/libdolphin/libdolphin/dolphin.py fox
