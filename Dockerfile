FROM alpine:edge

RUN apk update && \
    apk add --no-cache ca-certificates caddy wget unzip && \
    wget -O /tmp/Xray-linux-64.zip \
      https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/Xray-linux-64.zip -d / && \
    chmod +x /xray && \
    rm -rf /tmp/* /var/cache/apk/*

COPY config.json /config.json
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 443

CMD /start.sh
