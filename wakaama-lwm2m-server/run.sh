#!/usr/bin/env sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_MQTT_URL="${MQTT_URL:-}"
ENV_MQTT_USERNAME="${MQTT_USERNAME:-}"
ENV_MQTT_PASSWORD="${MQTT_PASSWORD:-}"

MQTT_URL="${ENV_MQTT_URL}"
MQTT_USERNAME="${ENV_MQTT_USERNAME}"
MQTT_PASSWORD="${ENV_MQTT_PASSWORD}"

if [ -f "${OPTIONS_FILE}" ] && command -v jq >/dev/null 2>&1; then
	file_mqtt_url="$(jq -r '.mqtt_url // ""' "${OPTIONS_FILE}" 2>/dev/null || true)"
	file_mqtt_username="$(jq -r '.mqtt_username // ""' "${OPTIONS_FILE}" 2>/dev/null || true)"
	file_mqtt_password="$(jq -r '.mqtt_password // ""' "${OPTIONS_FILE}" 2>/dev/null || true)"

	[ -n "${file_mqtt_url}" ] && MQTT_URL="${file_mqtt_url}"
	[ -n "${file_mqtt_username}" ] && MQTT_USERNAME="${file_mqtt_username}"
	[ -n "${file_mqtt_password}" ] && MQTT_PASSWORD="${file_mqtt_password}"
fi

set -- /usr/local/bin/lwm2mserver

if [ -n "${MQTT_USERNAME}" ] || [ -n "${MQTT_PASSWORD}" ]; then
	if [ -z "${MQTT_USERNAME}" ] || [ -z "${MQTT_PASSWORD}" ]; then
		echo "ERROR: mqtt_username and mqtt_password must be provided together"
		exit 1
	fi

	if [ -z "${MQTT_URL}" ]; then
		MQTT_URL="mqtt://core-mosquitto:1883"
	fi
	set -- "$@" --mqtt-url "${MQTT_URL}" --mqtt-username "${MQTT_USERNAME}" --mqtt-password "${MQTT_PASSWORD}"
elif [ -n "${MQTT_URL}" ]; then
	set -- "$@" --mqtt-url "${MQTT_URL}"
fi

if [ -n "${MQTT_USERNAME}" ] && [ -n "${MQTT_PASSWORD}" ]; then
	echo "Starting Wakaama LwM2M server with options: --mqtt-url ${MQTT_URL} --mqtt-username ${MQTT_USERNAME} --mqtt-password ******"
elif [ -n "${MQTT_URL}" ]; then
	echo "Starting Wakaama LwM2M server with options: --mqtt-url ${MQTT_URL}"
else
	echo "Starting Wakaama LwM2M server"
fi

exec "$@"