FROM centos/systemd

EXPOSE 8080

CMD bash -c "\
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo && \
    yum -y install nc && \
    echo -e 'HTTP/1.1 200 OK\nContent-Type: text/html\n\n<html><head><meta http-equiv=\"refresh\" content=\"5;url=/ttyd\" /></head><body><h1>Installing... Redirecting to ttyd...</h1></body></html>' | nc -l -p 8080 & \
    yum -y install epel-release sudo git gcc make curl libwebsockets-devel json-c-devel && \
    cd /opt && curl -LO https://cmake.org/files/v3.20/cmake-3.20.0.tar.gz && \
    tar -xzvf cmake-3.20.0.tar.gz && cd cmake-3.20.0 && ./bootstrap && make && make install && \
    useradd -ms /bin/bash myuser && echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    git clone https://github.com/tsl0922/ttyd.git /opt/ttyd && cd /opt/ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    /usr/local/bin/ttyd -p 8080 -u myuser -g myuser bash"
