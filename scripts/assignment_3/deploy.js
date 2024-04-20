const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const name = "Censorable Token";
  const symbol = "CTK";
  const initialSupply = 1000; // Not adjusted for decimals here; contract does it
  const initialOwner = "0xB0Ef9b483B38aaCF056421dfcE99DeaeB121Cf8a";
  const validator = "0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155";

  const Token = await hre.ethers.getContractFactory("CensorableToken");
  const token = await Token.deploy(
    name,
    symbol,
    initialSupply,
    initialOwner,
    validator
  );

  await token.deployed();

  console.log("Token deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
