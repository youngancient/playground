import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0xaDBA987955Eac146f1983062100046be46e632fA";

const SaveERC20Module = buildModule("SaveERC20Module", (m) => {

    const save = m.contract("SaveERC20", [tokenAddress]);

    return { save };
});

export default SaveERC20Module;

// Deployed SaveERC20: 0x9e92DE115F6c5a66c77062434Fa4F787Fd32daa9
