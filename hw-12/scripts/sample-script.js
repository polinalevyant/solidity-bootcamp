// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const VolcanoCoin = await hre.ethers.getContractFactory("VolcanoCoin");
  const volcanoCoin = await upgrades.deployProxy(VolcanoCoin);
  await volcanoCoin.deployed();
  console.log("VolcanoCoin deployed to:", volcanoCoin.address);

  // Upgrade contract
  const VolcanoCoin2 = await ethers.getContractFactory("VolcanoCoin2");
  const volcanoCoin2 = await upgrades.upgradeProxy(volcanoCoin.address, VolcanoCoin2);
  await volcanoCoin2.deployed();
  console.log("VolcanoCoin2 deployed to:", volcanoCoin2.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });