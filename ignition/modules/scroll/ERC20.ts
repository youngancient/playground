import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";

const ScrollRollModule = buildModule("ScrollRollModule", (m) => {
    
  const initialSupply = ethers.parseUnits("1000000", 18);
  const erc20 = m.contract("MyToken", [initialSupply]);

  return { erc20 };
});

export default ScrollRollModule;
