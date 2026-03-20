FROM debian:bookworm-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY lwm2mserver /usr/local/bin/lwm2mserver
COPY run.sh /run.sh
RUN chmod +x /usr/local/bin/lwm2mserver /run.sh

EXPOSE 5683/udp
EXPOSE 8088/tcp

ENTRYPOINT ["/run.sh"]