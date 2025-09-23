#!/bin/sh
geth --sepolia --syncmode="snap" --http --http.api eth,net,web3 --cache=1024 --http.port 8545 --http.addr 127.0.0.1 --http.corsdomain "*"
