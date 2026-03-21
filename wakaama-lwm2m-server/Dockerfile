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
            amd64) candidate="/opt/addon/lwm2mserver-amd64"; eddsa_candidate="/opt/addon/libeddsa-amd64.so.0" ;; \
            arm64|aarch64) candidate="/opt/addon/lwm2mserver-arm64"; eddsa_candidate="/opt/addon/libeddsa-arm64.so.0" ;; \
            *) candidate="" ;; \
        esac; \
        if [ -n "$candidate" ] && [ -f "$candidate" ]; then \
            cp "$candidate" /usr/local/bin/lwm2mserver; \
            echo "Using arch-specific binary: $candidate"; \
        else \
            cp /opt/addon/lwm2mserver /usr/local/bin/lwm2mserver; \
            echo "Using fallback binary: /opt/addon/lwm2mserver"; \
        fi; \
        if [ -n "${eddsa_candidate:-}" ] && [ -f "$eddsa_candidate" ]; then \
            cp "$eddsa_candidate" /usr/local/lib/libeddsa.so.0; \
            ln -sf /usr/local/lib/libeddsa.so.0 /usr/local/lib/libeddsa.so; \
            echo "Installed runtime lib: $eddsa_candidate"; \
        else \
            echo "WARNING: No architecture-specific libeddsa runtime found at ${eddsa_candidate:-<none>}"; \
        fi; \
        cp /opt/addon/run.sh /run.sh; \
        mkdir -p /usr/lib/lua/luci/edgez/sensors; \
        if [ -d /opt/addon/sensors ]; then \
            cp -a /opt/addon/sensors/. /usr/lib/lua/luci/edgez/sensors/; \
        fi; \
        chmod +x /usr/local/bin/lwm2mserver /run.sh

EXPOSE 5683/udp
EXPOSE 8088/tcp
EXPOSE 4001/tcp

ENV EDGEZ_CONFIG_FILE=/data/edgez/uci_fallback.conf
ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]