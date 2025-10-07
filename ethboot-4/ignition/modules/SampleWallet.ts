import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("SampleWalletModule", (m) => {
  const wallet = m.contract("SampleWallet");

  return { wallet };
});
