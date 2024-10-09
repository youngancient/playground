import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    // for testnet
    "scrollSepolia": {
      // url: process.env.LISK_RPC_URL!,
      url: process.env.SCROLL_SEPOLIA_RPC_URL!,
      accounts: [
        process.env.ACCOUNT_PRIVATE_KEY!,
        // process.env.ACCOUNT_PRIVATE_KEY1!,
        // process.env.ACCOUNT_PRIVATE_KEY2!,
      ],
      gasPrice: 1000000000,
    },
  },
  etherscan: {
    apiKey: {
      scrollSepolia: process.env.SCROLL_SEPOLIA_ETHERSCAN_API_KEY!,
    },
    customChains: [
      {
        network: 'scrollSepolia',
        chainId: 534351,
        urls: {
          apiURL: 'https://api-sepolia.scrollscan.com/api',
          browserURL: 'https://sepolia.scrollscan.com/',
        },
      },
    ],
  },
  // lisk
  // etherscan: {
  //   // Use "123" as a placeholder, because Blockscout doesn't need a real API key, and Hardhat will complain if this property isn't set.
  //   apiKey: {
  //     "lisk-sepolia": "123",
  //   },
  //   customChains: [
  //     {
  //       network: "lisk-sepolia",
  //       chainId: 4202,
  //       urls: {
  //         apiURL: "https://sepolia-blockscout.lisk.com/api",
  //         browserURL: "https://sepolia-blockscout.lisk.com/",
  //       },
  //     },
  //   ],
  // },
 
};

export default config;
