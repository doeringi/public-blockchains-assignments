const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Define constructor parameters
  const initialOwner = deployer.address;

  // Deploy CensorableToken contract
  console.log("Deploying NFTMinter contract...");

  const NFTMinter = await hre.ethers.deployContract("NFTMinter", [
    initialOwner,
    "0x43E66d5710F52A2D0BFADc5752E96f16e62F6a11",
  ]);

  await NFTMinter.deployTransaction.wait();

  console.log(`NFTMinter deployed to ${NFTMinter.address}`);

  console.log("Deployment completed");
}

// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
