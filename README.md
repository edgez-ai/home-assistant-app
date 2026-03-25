# home-assistant-addon

Home Assistant add-on repository for EdgeZ services.

## Add-ons

- `wakaama-lwm2m-server/` - Runs the EdgeZ Wakaama LwM2M server.

### Wakaama add-on notes

- Current add-on `arch` is `aarch64` only.
- For Home Assistant add-on networking, use the broker container hostname (typically `core-mosquitto`) instead of `homeassistant.local`.
- If MQTT username/password are set in add-on options and URL is empty, runtime default URL is `mqtt://core-mosquitto:1883`.
- Add-on options `cloud_serial` and `cloud_join_key` are supported and mapped to server args `--cloud-serial` and `--cloud-join-key`.
- When `cloud_join_key` is set, the server enables cloud mode.

## Binary supply chain

The `lwm2mserver` binary in `wakaama-lwm2m-server/lwm2mserver` is updated by the
`wakaama-server` CI workflow (arm64 build) and committed into this repository.
