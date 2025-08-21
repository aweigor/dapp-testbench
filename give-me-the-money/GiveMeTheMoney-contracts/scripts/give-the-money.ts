import helpers from "@nomicfoundation/hardhat-network-helpers";
import { Addressable } from "ethers";

require("@nomicfoundation/hardhat-ethers");
import hre from "hardhat";

interface Memo {
  timestamp: number;
  name: string;
  from: Addressable;
  message: string;
}

const { ethers } = await hre.network.connect({
  network: "sepolia",
  chainType: "l1",
});

async function getBalance(address: string) {
  const balanceBigInt = await ethers.provider.getBalance(address);
  return ethers.formatEther(balanceBigInt);
}

async function printBalances(addresses: string[]) {
  let idx = 0;
  for (const address of addresses) {
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

async function printMemos(memos: Memo[]) {
  for (const memo of memos) {
    const { timestamp, name, from, message } = memo;
    console.log(`at ${timestamp}, ${name} (${from}) said: ${message}`);
  }
}

async function main() {
  // get example accounts
  const [owner, tipper1, tipper2, tipper3] = await ethers.getSigners();

  // get contract and deploy
  const GiveMeTheMoney = await ethers.getContractFactory("GiveMeTheMoney");
  const giveMeTheMoney = await GiveMeTheMoney.deploy();
  await giveMeTheMoney.deployed();
  const contractAddress = await giveMeTheMoney.getAddress();
  console.log("contract deployed to ", contractAddress);

  // check balances
  const addresses = [owner.address, tipper1.address, contractAddress];
  console.log("check address start");
  await printBalances(addresses);

  //
}

main()
  .then(() => process.exit(0))
  .catch((ex) => {
    console.error(ex);
    process.exit(1);
  });
