import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import { mainnet } from "viem/chains";
import { createWalletClient, http } from "viem";

describe("Messenger", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const client = createWalletClient({
    chain: mainnet,
    transport: http(),
  });

  it("Should emit the Increment event when calling the inc() function", async function () {
    const messenger = await viem.deployContract("Messenger");
    const deploymentBlockNumber = await publicClient.getBlockNumber();

    const addresses = await client.getAddresses();

    // run a series of increments
    let total = 10n;
    for (let i = 1n; i <= 10n; i++) {
      await messenger.write.updateTheMessage(["Hello"]);
    }

    assert.equal(total, await messenger.read.changeCounter());
  });
});
