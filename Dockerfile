FROM ubuntu:16.04

ADD files/sources.list /etc/apt/sources.list
RUN apt-get update && \
    apt-get install software-properties-common python-software-properties gcc -y && \
    apt-add-repository ppa:dolphin-emu/ppa

RUN apt-get update && apt-get install git -y && \
    apt-get -y install libgl1-mesa-glx libgl1-mesa-dri && \
    apt-get -y install alsa-utils && \
    apt-get install python python-pip python-virtualenv -y

RUN apt install cmake pkg-config git libao-dev libasound2-dev \
    libavcodec-dev libavformat-dev libbluetooth-dev libenet-dev \
    libgtk2.0-dev liblzo2-dev libminiupnpc-dev libopenal-dev \
    libpulse-dev libreadline-dev libsfml-dev libsoil-dev \
    libsoundtouch-dev libswscale-dev libusb-1.0-0-dev libwxbase3.0-dev \
    libwxgtk3.0-dev libxext-dev libxrandr-dev portaudio19-dev zlib1g-dev \
    libudev-dev libevdev-dev "libpolarssl-dev|libmbedtls-dev" \
    libcurl4-openssl-dev libegl1-mesa-dev libpng-dev qtbase5-private-dev -y

RUN export uid=1001 gid=33 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN git clone https://github.com/squidboylan/dolphin.git \
    /home/developer/dolphin && mkdir /home/developer/dolphin/build && \
    cd /home/developer/dolphin/build ; git checkout memorywatcher-fork; \
    cmake .. ; make -j4 ; make install ; \
    rm -rf /home/developer/dolphin

RUN mkdir -p /home/developer/.local/share/dolphin-emu/Games && \
    mkdir -p /home/developer/.local/share/dolphin-emu/MemoryWatcher && \
    mkdir -p /home/developer/.local/share/dolphin-emu/Pipes && \
    mkdir -p /home/developer/.config/dolphin-emu

#RUN apt-get install x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable \
    #xfonts-cyrillic x11-apps -y

RUN apt-get install xvfb -y

RUN chown -Rh developer /home/developer

ENV PATH /home/squid/firefox:/home/squid/bin:/home/squid/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/sbin
RUN rm -rf /var/lib/apt/lists/*

ADD files/start.sh /home/developer/start.sh
ADD files/GameSettings /home/developer/.local/share/dolphin-emu/GameSettings
ADD files/dolphin-emu /home/developer/.config/dolphin-emu
ADD files/start.sh /home/developer/start.sh

RUN chown developer -Rh /home/developer ; chmod +x /home/developer/start.sh

USER developer
ENV HOME /home/developer

CMD ["/home/developer/start.sh"]
