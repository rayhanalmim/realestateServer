// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const GOVERNMENT_ACCOUNT_ADDRESS =
    "0xEF4Eef3FFdA3E05D347986862726a955353A2227";

  // We get the contract to deploy
  const Marketplace = await ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy(GOVERNMENT_ACCOUNT_ADDRESS);

  await marketplace.deployed();

  console.log("Marketplace deployed: ", marketplace.address);

  const PropertyNFT = await ethers.getContractFactory("PropertyNFT");
  const nft = await PropertyNFT.deploy(marketplace.address);
  await nft.deployed();

  console.log("PropertyNFT deployed: ", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
