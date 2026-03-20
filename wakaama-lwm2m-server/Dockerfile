FROM debian:bookworm-slim

ARG TARGETARCH

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        jq \
        libmicrohttpd12 \
        libmosquitto1 \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/addon

RUN set -eu; \
        arch="${TARGETARCH:-}"; \
        if [ -z "$arch" ]; then \
            arch="$(dpkg --print-architecture)"; \
        fi; \
        case "$arch" in \
            amd64) candidate="/opt/addon/lwm2mserver-amd64" ;; \
            arm64|aarch64) candidate="/opt/addon/lwm2mserver-arm64" ;; \
            *) candidate="" ;; \
        esac; \
        if [ -n "$candidate" ] && [ -f "$candidate" ]; then \
            cp "$candidate" /usr/local/bin/lwm2mserver; \
            echo "Using arch-specific binary: $candidate"; \
        else \
            cp /opt/addon/lwm2mserver /usr/local/bin/lwm2mserver; \
            echo "Using fallback binary: /opt/addon/lwm2mserver"; \
        fi; \
        cp /opt/addon/run.sh /run.sh; \
        mkdir -p /usr/lib/lua/luci/edgez/sensors; \
        if [ -d /opt/addon/sensors ]; then \
            cp -a /opt/addon/sensors/. /usr/lib/lua/luci/edgez/sensors/; \
        fi; \
        chmod +x /usr/local/bin/lwm2mserver /run.sh

EXPOSE 5683/udp
EXPOSE 8088/tcp

ENV EDGEZ_CONFIG_FILE=/data/edgez/uci_fallback.conf
VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]