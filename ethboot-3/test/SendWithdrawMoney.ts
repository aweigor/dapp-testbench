import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import { mainnet } from "viem/chains";
import { createWalletClient, http } from "viem";

describe("SendWithdrawMoney", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const client = createWalletClient({
    chain: mainnet,
    transport: http(),
  });

  it("Should show deposited value on the balance", async function () {
    const contract = await viem.deployContract("SendWithdrawMoney");

    await contract.write.deposit({ value: 1000n });

    assert.equal(1000n, await contract.read.getContractBalance());
  });
});
