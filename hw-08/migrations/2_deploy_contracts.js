var VolcanoToken = artifacts.require("VolcanoToken");
module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(VolcanoToken);
};