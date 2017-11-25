FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install software-properties-common python-software-properties -y && \
    apt-add-repository ppa:dolphin-emu/ppa && \
    apt-get update && apt-get install dolphin-emu-master git -y && \
    apt-get install python python-pip python-virtualenv -y

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
ENV DISPLAY :0

RUN git clone https://github.com/squidboylan/libdolphin.git /home/developer/libdolphin
RUN chown -Rh developer /home/developer/libdolphin
RUN virtualenv /home/developer/venv -p /usr/bin/python2 && \
    /home/developer/venv/bin/pip install -r \
    /home/developer/libdolphin/requirements.txt && chown -Rh developer /home/developer/venv

CMD ["/usr/games/dolphin-emu"]
