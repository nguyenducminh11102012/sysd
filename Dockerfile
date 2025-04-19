FROM ubuntu:20.04

ENV container docker
ENV DEBIAN_FRONTEND=noninteractive

# Cài systemd, sudo và tiện ích cần thiết
RUN apt update && \
    apt install -y systemd systemd-sysv sudo curl build-essential cmake git libjson-c-dev libwebsockets-dev

# Tạo user
RUN useradd -ms /bin/bash myuser && \
    echo 'myuser:password' | chpasswd && \
    usermod -aG sudo myuser

# Cài ttyd từ source
RUN git clone https://github.com/tsl0922/ttyd.git /opt/ttyd && \
    cd /opt/ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Tạo systemd service cho ttyd
RUN mkdir -p /etc/systemd/system
RUN echo "[Unit]\
\nDescription=ttyd Terminal\
\nAfter=network.target\
\n\
\n[Service]\
\nExecStart=/usr/local/bin/ttyd -p 7681 -u myuser -g myuser bash\
\nRestart=always\
\n\
\n[Install]\
\nWantedBy=multi-user.target" > /etc/systemd/system/ttyd.service

# Enable ttyd
RUN systemctl enable ttyd.service

# Expose cổng của ttyd
EXPOSE 7681

STOPSIGNAL SIGRTMIN+3

CMD ["/lib/systemd/systemd"]
