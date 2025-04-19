FROM centos/systemd

EXPOSE 8080

CMD bash -c " \
    echo 'HTTP/1.1 200 OK\nContent-Type: text/html\n\n<html><body><h1>installing...</h1></body></html>' | nc -l -p 8080 & \
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo && \
    yum -y install epel-release sudo git gcc make libwebsockets-devel json-c-devel curl nc && \
    useradd -ms /bin/bash myuser && \
    echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    # Cài đặt CMake phiên bản mới
    cd /opt && \
    curl -LO https://cmake.org/files/v3.20/cmake-3.20.0.tar.gz && \
    tar -xzvf cmake-3.20.0.tar.gz && \
    cd cmake-3.20.0 && \
    ./bootstrap && \
    make && \
    make install && \
    # Kiểm tra phiên bản CMake mới
    cmake --version && \
    git clone https://github.com/tsl0922/ttyd.git /opt/ttyd && \
    cd /opt/ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    # Kiểm tra ttyd đã cài đúng chưa
    ls /usr/local/bin/ttyd && \
    # Sau khi cài đặt hoàn tất, redirect sang ttyd
    echo 'HTTP/1.1 302 Found\nLocation: /ttyd\n\n' | nc -l -p 8080 & \
    /usr/local/bin/ttyd -p 8080 -u myuser -g myuser bash"
