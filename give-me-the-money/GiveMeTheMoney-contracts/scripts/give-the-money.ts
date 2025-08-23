import { Addressable } from "ethers";
import hre from "hardhat";

interface Memo {
  timestamp: number;
  name: string;
  from: Addressable;
  message: string;
}

const { ethers } = await hre.network.connect({
  network: "hardhatOp",
  chainType: "op",
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
  await giveMeTheMoney.waitForDeployment();
  const contractAddress = await giveMeTheMoney.getAddress();
  console.log("contract deployed to ", contractAddress);

  // check balances
  const addresses = [owner.address, tipper1.address, contractAddress];
  console.log("*** initial balances ***");
  await printBalances(addresses);

  // give the owner some money
  const tip = { value: ethers.parseEther("1") };
  await giveMeTheMoney.connect(tipper1).giveTheMoney("Garry", "Sorry", tip);
  await giveMeTheMoney.connect(tipper2).giveTheMoney("Elona", "Thank you", tip);
  await giveMeTheMoney.connect(tipper3).giveTheMoney("Kenny", "haha", tip);

  // check balances
  console.log("*** money received balances ***");
  await printBalances(addresses);

  // widthdraw money
  await giveMeTheMoney.connect(owner).withdrawTheMoney();

  // check balances
  console.log("*** money withdrawed ***");
  await printBalances(addresses);

  // read memos
  console.log("*** memos ***");
  const memos = await giveMeTheMoney.getMemos();
  printMemos(memos);
}

main()
  .then(() => process.exit(0))
  .catch((ex) => {
    console.error(ex);
    process.exit(1);
  });
