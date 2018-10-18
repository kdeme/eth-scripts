#!/usr/bin/env bash

# ID from boot.key
BOOTNODE_ID="f41f87f084ed7df4a9fd0833e395f49c89764462d3c4bc16d061a3ae5e3e34b79eb47d61c2f62db95ff32ae8e20965e25a3c9d9b8dbccaa8e8d77ac6fc8efc06"
BOOTNODE_IP="$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bootnode)"
BOOTNODE_PORT="30301"

usage() { echo "Usage: $0 -i <identity> -p <port>" 1>&2; exit 1; }

while getopts ":i:p:" opt; do
    case "${opt}" in
        i)
            IDENTITY=${OPTARG}
            ;;
        p)
            PORT=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${IDENTITY}" ] || [ -z "${PORT}" ]; then
    usage
fi

sudo docker run -it -p ${PORT}:${PORT} \
  -e BOOTNODE_ID=${BOOTNODE_ID} \
  -e BOOTNODE_IP=${BOOTNODE_IP} \
  -e BOOTNODE_PORT=${BOOTNODE_PORT} \
  -e IDENTITY=${IDENTITY} \
  -e PORT=${PORT} \
  deme/testnet /usr/geth/start_shh_node.sh
