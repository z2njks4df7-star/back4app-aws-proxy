# Back4App AWS 免费代理部署包 —— sing-box VLESS+WebSocket 入站镜像
# 参考开源方案：hupan0210/nlbw-vps（Back4App 容器引擎 + sing-box）
# 目标平台：linux/amd64（Back4App 容器引擎默认 x86_64）

FROM alpine:3.20

ARG SING_BOX_VERSION=1.14.3
ARG TARGETARCH=amd64

RUN apk add --no-cache ca-certificates tzdata wget \
    && wget -q -O /tmp/sing-box.tar.gz \
       "https://github.com/SagerNet/sing-box/releases/download/v${SING_BOX_VERSION}/sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}.tar.gz" \
    && tar -xzf /tmp/sing-box.tar.gz -C /tmp \
    && mv /tmp/sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}/sing-box /usr/local/bin/sing-box \
    && chmod +x /usr/local/bin/sing-box \
    && rm -rf /tmp/sing-box* \
    && mkdir -p /etc/sing-box

COPY config.json /etc/sing-box/config.json

EXPOSE 443

CMD ["sing-box", "run", "-c", "/etc/sing-box/config.json"]
