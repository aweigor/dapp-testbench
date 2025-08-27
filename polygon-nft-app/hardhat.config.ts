import type { HardhatUserConfig } from "hardhat/config";

import hardhatToolboxMochaEthersPlugin from "@nomicfoundation/hardhat-toolbox-mocha-ethers";
import { configVariable } from "hardhat/config";

import { config as c } from "dotenv";

c();

const config: HardhatUserConfig = {
  
  plugins: [hardhatToolboxMochaEthersPlugin],
  solidity: {
    profiles: {
      default: {
        version: "0.8.28",
      },
      production: {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  },
  networks: {
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    amoy: {
      type: "http",
      chainType: "l1",
      url: process.env.CHAIN_URL!,
      accounts: [process.env.PK!],
    },
  },
  verify: {
    etherscan: {
      apiKey: process.env.POLYGON_API_KEY!,
    },
  },
};

export default config;
