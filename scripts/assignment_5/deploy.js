async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const StateChannel = await ethers.deployContract("StateChannel", [
    "0xD262826BfEF5C03677b26C71FB1136Ab1c1e4863",
  ]);

  //   await StateChannel.;

  console.log("StateChannel deployed to:", StateChannel.address);

  console.log("Deployment completed");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
