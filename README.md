# home-assistant-addon

Home Assistant add-on repository for EdgeZ services.

## Add-ons

- `wakaama-lwm2m-server/` - Runs the EdgeZ Wakaama LwM2M server.

## Binary supply chain

The `lwm2mserver` binary in `wakaama-lwm2m-server/lwm2mserver` is updated by the
`wakaama-server` CI workflow (arm64 build) and committed into this repository.
