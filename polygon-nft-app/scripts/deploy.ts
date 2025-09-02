import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "amoy",
  chainType: "l1",
});

async function main() {
  const GiveMeTheMoney = await ethers.getContractFactory("ChainBattles");
  const giveMeTheMoney = await GiveMeTheMoney.deploy();
  await giveMeTheMoney.waitForDeployment();
  const contractAddress = await giveMeTheMoney.getAddress();
  console.log("contract deployed to ", contractAddress);
}

main()
  .then(() => process.exit(0))
  .catch((ex) => {
    console.error(ex);
    process.exit(1);
  });
