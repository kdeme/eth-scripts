#!/usr/bin/env sh
geth --identity ${IDENTITY} --datadir testnetdata init genesis.json
geth --identity ${IDENTITY} --datadir testnetdata --port ${PORT} --bootnodes="enode://${BOOTNODE_ID}@${BOOTNODE_IP}:${BOOTNODE_PORT}" --shh console
