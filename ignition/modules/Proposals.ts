import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ProposalsModule = buildModule("ProposalsModule", (m) => {

    const proposal = m.contract("ProposalContract");

    return { proposal };
});

export default ProposalsModule;
