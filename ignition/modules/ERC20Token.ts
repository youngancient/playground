import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CampaignTokenModule = buildModule("CampaignTokenModule", (m) => {

    const erc20 = m.contract("CampaignToken");

    return { erc20 };
});

export default CampaignTokenModule;
