#!/usr/bin/env sh
set -eu

MQTT_URL="${MQTT_URL:-}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"

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