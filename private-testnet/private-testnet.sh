#!/usr/bin/env bash

source ./lib/setup/packages.sh
source ./lib/setup/platform.sh

source ./add-contracts.sh

# TODO: Move to script arguments
NODE_HOST="192.168.1.99"
NODE_PORT="7545"

function install_ganache() {
  if ! program_exists "ganache-cli"; then
    local npm_command="npm"
    if is_linux && ! nvm_installed; then
      # aptitude version of node requires sudo for global install
      npm_command="sudo npm"
    fi
    $npm_command install -g ganache-cli
  fi
}

PID_FILE="/run/user/$UID/ganache.pid"

case "$1" in
  start)
    install_ganache
    init_truffle $NODE_HOST $NODE_PORT
    ganache-cli -h $NODE_HOST -p $NODE_PORT -d &
    echo $!>$PID_FILE
    deploy_sob_contracts
    deploy_fst_contracts
    ;;
  stop)
    kill `cat $PID_FILE`
    rm $PID_FILE
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    if [ -e $PID_FILE ]; then
      echo Ganache is running, pid=`cat $PID_FILE`
    else
      echo Ganache is NOT running
      exit 1
    fi
    ;;
  *) echo "Usage: $0 {start|stop|status|restart}"; exit 1
esac

exit 0
