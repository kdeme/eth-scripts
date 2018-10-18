FROM ethereum/client-go:alltools-stable
RUN mkdir -p /usr/geth/testnetdata
COPY genesis.json /usr/geth
COPY boot.key /usr/geth
COPY start_shh_node.sh /usr/geth
WORKDIR /usr/geth
