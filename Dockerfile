FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install software-properties-common python-software-properties -y && \
    apt-add-repository ppa:dolphin-emu/ppa

RUN apt-get update && apt-get install dolphin-emu-master git -y && \
    apt-get -y install libgl1-mesa-glx libgl1-mesa-dri && \
    apt-get -y install alsa-utils && \
    apt-get install python python-pip python-virtualenv -y

RUN export uid=1000 gid=33 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    #echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN git clone https://github.com/squidboylan/libdolphin.git /home/developer/libdolphin

RUN mkdir -p /home/developer/.local/share/dolphin-emu/Games && \
    mkdir -p /home/developer/.local/share/dolphin-emu/MemoryWatcher && \
    mkdir -p /home/developer/.local/share/dolphin-emu/Pipes && \
    mkdir -p /home/developer/.config/dolphin-emu

RUN chown -Rh developer /home/developer

RUN virtualenv /home/developer/venv -p /usr/bin/python3 && \
    /home/developer/venv/bin/pip install -r \
    /home/developer/libdolphin/requirements.txt && \
    /home/developer/venv/bin/pip install -e /home/developer/libdolphin && chown -Rh developer /home/developer/venv

ENV PATH /home/squid/firefox:/home/squid/bin:/home/squid/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/sbin:/usr/games/
RUN rm -rf /var/lib/apt/lists/*

USER developer
ENV HOME /home/developer
ENV DISPLAY :0


CMD ["/home/developer/venv/bin/python3", "/home/developer/libdolphin/libdolphin/dolphin.py", "fox"]
