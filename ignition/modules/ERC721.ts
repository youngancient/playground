import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const PepeModule = buildModule("PepeModule", (m) => {

    const nft = m.contract("ClownPepe");

    return { nft };
});

export default PepeModule;
