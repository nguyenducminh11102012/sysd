# Sử dụng image franela/dind làm base image
FROM franela/dind:latest

# Cài đặt các dependencies cần thiết
RUN apk add --no-cache \
    bash \
    git \
    cmake \
    g++ \
    make \
    curl \
    libwebsockets-dev \
    json-c-dev \
    && rm -rf /var/cache/apk/*

# Cài đặt ttyd từ source
RUN git clone https://github.com/tsl0922/ttyd.git /opt/ttyd \
    && cd /opt/ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

# Tạo user cho ttyd
RUN useradd -ms /bin/bash myuser && echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Cấu hình ttyd chạy trên port 8080
CMD /usr/local/bin/ttyd -p 8080 -u myuser -g myuser bash
