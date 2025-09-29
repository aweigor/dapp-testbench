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

  it("Should do something...", async function () {
    // todo: test
  });
});
