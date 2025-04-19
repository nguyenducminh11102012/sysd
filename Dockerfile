FROM centos/systemd

EXPOSE 8080

CMD yum -y install epel-release sudo git cmake gcc make libwebsockets-devel json-c-devel curl && \
    useradd -ms /bin/bash myuser && \
    echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    git clone https://github.com/tsl0922/ttyd.git /opt/ttyd && \
    cd /opt/ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    /usr/local/bin/ttyd -p 8080 -u myuser -g myuser bash
