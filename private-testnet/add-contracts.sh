#!/usr/bin/env bash

source ./lib/setup/packages.sh
source ./lib/setup/platform.sh

CURRENT_DIR="$( pwd )"
TRUFFLE_DIR="$CURRENT_DIR/truffle-data"
CONTRACTS_DIR="$TRUFFLE_DIR/contracts"

#NODE_HOST="192.168.1.99"
#NODE_PORT="7545"

function install_truffle() {
  if ! program_exists "truffle"; then
    local npm_command="npm"
    if is_linux && ! nvm_installed; then
      # aptitude version of node requires sudo for global install
      npm_command="sudo npm"
    fi
    $npm_command install -g truffle
  fi
}

function init_truffle() {
  install_truffle

  local node_host=$1
  local node_port=$2

  if [ ! -d "$TRUFFLE_DIR" ]; then
    mkdir $TRUFFLE_DIR
    cd $TRUFFLE_DIR
    truffle init
    rm truffle-config.js # unnecessary file unless you are on Windows
    sed -i '/};/i networks: { development: { host: "'$node_host'", port: '$node_port', network_id: "*" } }' truffle.js
    cd ..
  fi
}

function deploy_sob_contracts() {
  cp ./2_deploy_sob_contracts.js $TRUFFLE_DIR/migrations/

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/ERC20.sol \
    -o $CONTRACTS_DIR/ERC20.sol

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/MultiSigFactory.sol \
    -o $CONTRACTS_DIR/MultiSigFactory.sol

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/MultiSigStub.sol \
    -o $CONTRACTS_DIR/MultiSigStub.sol

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/MultiSigTokenWallet.sol \
    -o $CONTRACTS_DIR/MultiSigTokenWallet.sol

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/TestToken.sol \
    -o $CONTRACTS_DIR/TestToken.sol

  curl --silent \
  https://raw.githubusercontent.com/status-im/open-bounty/develop/contracts/TokenReg.sol \
    -o $CONTRACTS_DIR/TokenReg.sol

  cd $TRUFFLE_DIR
  truffle compile
  truffle migrate --network development
  cd ..
}

function deploy_fst_contracts(){
  cp ./3_deploy_fst_contracts.js $TRUFFLE_DIR/migrations/

  curl --silent \
    https://raw.githubusercontent.com/bokkypoobah/Tokens/master/contracts/FixedSupplyToken.sol \
    -o $TRUFFLE_DIR/contracts/FixedSupplyToken.sol

  cd $TRUFFLE_DIR
  truffle compile
  truffle migrate --network development
  cd ..
}
