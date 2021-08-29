#!/bin/sh
set -e
if [ "$1" = "litecoin" ]; then

  litecoind_setup.sh

  echo "#####################################################"
  echo "# Configuration used: /data/litecoin/litecoin.conf  #"
  echo "#####################################################"
  echo ""
  cat /data/litecoin/litecoin.conf
  echo ""
  echo "#####################################################"

  exec litecoind -datadir=/data/litecoin -conf=/data/litecoin/litecoin.conf -printtoconsole

fi
exec "$@"
