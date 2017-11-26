#!/bin/bash -xe

git clone https://github.com/squidboylan/libdolphin.git /home/developer/libdolphin

virtualenv /home/developer/venv -p /usr/bin/python3 && \
    /home/developer/venv/bin/pip install -r \
    /home/developer/libdolphin/requirements.txt && \
    /home/developer/venv/bin/pip install -e /home/developer/libdolphin

/home/developer/venv/bin/python3 /home/developer/libdolphin/libdolphin/dolphin.py fox
