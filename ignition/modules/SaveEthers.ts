import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SaveModule = buildModule("SaveModule", (m) => {

    const save = m.contract("EtherSafe");

    return { save };
});

export default SaveModule;

