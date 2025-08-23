# Give me the money dapp project

This test project implementing basic login of deploying simple contract for sending and receiving the crypto and storing memos. Using hardhat toolchain to interact with the network. Using sepolia testnet for deployment and interactions. Based on the Alchemy lesson @roadToWeb3(#2).

## Project Overview

Features:

- Smart contract code for sending money. withdraw tips and getting memos.
- A set of functions to deploy and interact with the contract.
- Available actions: send money, view balbnces, print memos.

## Usage

### Make a deployment to Sepolia

```shell
npx hardhat run scripts/deploy.ts;
```

### Testing the contract by calling methods and printing results

```shell
npx hardhat run scripts/give-the-money.ts;
```
