import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CampTokenModule = buildModule("CampTokenModule", (m) => {

    const erc20 = m.contract("CampToken");

    return { erc20 };
});

export default CampTokenModule;
