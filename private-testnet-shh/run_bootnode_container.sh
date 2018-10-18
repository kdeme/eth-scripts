#!/usr/bin/env bash
sudo docker run -it -p 30303:30303 -p 30303:30303/udp -p 30301:30301/udp --name bootnode deme/testnet bootnode --nodekey=boot.key
