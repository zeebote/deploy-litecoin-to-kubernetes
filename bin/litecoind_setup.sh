#!/bin/sh

set -e
# skip if conf already exit
if [ -e "/data/litecoin/litecoin.conf" ]; then
    exit 0
fi

# default from Dockerfile args
if [ -z ${DISABLE_WALLET} ]; then
    echo "disablewallet=1" >> "/data/litecoin/litecoin.conf"
else
    echo "disablewallet=${DISABLE_WALLET}" >> "/data/litecoin/litecoin.conf"   
fi

if [ -z ${MAX_CONNECTIONS} ]; then
    echo "maxconnections=20" >> "/data/litecoin/litecoin.conf"
else 
    echo "maxconnections=${MAX_CONNECTIONS}" >> "/data/litecoin/litecoin.conf"
fi

if [ -z ${TESTNET} ]; then
    echo "testnet=1" >> "/data/litecoin/litecoin.conf"
else
    echo "testnet=${TESTNET}" >> "/data/litecoin/litecoin.conf"
fi

if [ -z ${RPC_SERVER} ]; then
    echo "server=1" >> "/data/litecoin/litecoin.conf"
    # generate passwd with rpcauth.py
    rpcauth.py litecoinrpc >> "/data/litecoin/litecoin.conf"
    sed -i '/String to be appended/s/^/#/' /data/litecoin/litecoin.conf
    sed -i '/Your password/s/^/#/' /data/litecoin/litecoin.conf
else 
    echo "server=0" >> "/data/litecoin/litecoin.conf"
fi
