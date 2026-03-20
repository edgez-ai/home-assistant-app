#!/usr/bin/env sh
set -eu

ARGS="${ARGS:--4}"

echo "Starting Wakaama LwM2M server with args: ${ARGS}"
exec /usr/local/bin/lwm2mserver ${ARGS}