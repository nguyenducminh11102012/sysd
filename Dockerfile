FROM alpine:latest

# Cài đặt ttyd và các dependencies khác
RUN apk add --no-cache \
    ttyd \
    bash \
    git \
    cmake \
    g++ \
    make \
    curl \
    libwebsockets-dev \
    json-c-dev \
    zlib-dev

# Mở cổng 8080
EXPOSE 8080

# Khởi chạy ttyd trên cổng 8080
CMD ["ttyd", "-W", "-p", "8080", "bash"]
