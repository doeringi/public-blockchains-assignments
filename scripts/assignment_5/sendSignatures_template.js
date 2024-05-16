const hre = require("hardhat");
const ethers = hre.ethers;

const path = require("path");

const web3 = require("web3");

async function main() {
  // Retrieve signers from Hardhat (as defined in the hardhat.config.js file).
  const [signer1, signer2, signer3] = await ethers.getSigners();

  // Pick the deployer (default is signer1).
  const signer = signer1;
  console.log("Signer is:", signer.address);

  // TODO: adjust as needed.
  pathToABI = path.join(
    __dirname,
    "..",
    "..",
    "artifacts",
    "contracts",
    "assignment_5",
    "StateChannel.sol",
    "StateChannel.json"
  );

  const ABI = require(pathToABI).abi;
  // console.log(ABI);

  // TODO: update with your
  // Contract address of the payment channel.
  const contractAddr = "0xD54fc9ddbEEEb768fF8d10C78FACeB7b774dA929";

  // Create contract with attached signer.
  const contract = new ethers.Contract(contractAddr, ABI, signer);

  const getSignature = async (amount) => {
    // Solidity encode packed the hash of address and ETH amount.
    // Hint: https://docs.ethers.org/v6/api/hashing/#solidityPackedKeccak256

    // TODO: Complete the code.
    const hashedMsg = ethers.utils.solidityKeccak256(
      ["address", "uint256"],
      [contractAddr, amount]
    );
    console.log("Hashed msg", hashedMsg);

    // Transform to Bytes array before signining.
    const hashedArray = ethers.utils.arrayify(hashedMsg);

    console.log("Hashed array", hashedArray);

    // Sign.

    // TODO: Complete the code.
    const signature = await signer.signMessage(hashedArray);

    console.log("signMessage hashed", signature);

    return signature;
  };

  const sendSignature = async (idx, amount) => {
    let sig = await getSignature(amount);

    // TODO: send the signature to the contract, follow instructions
    // on assignment.
    const tx = await contract.addSignature(idx, sig, amount);

    await tx.wait();
  };

  console.log("Adding signatures.");

  // TODO: complete the code.

  await sendSignature(0, 200);
  await sendSignature(1, 100);

  console.log("Signatures added, verifying");

  let s = await contract.getSignature(0);
  console.log("Sig 0", s);
  s = await contract.getSignatureEthAmount(0);
  console.log("Eth 0", s);

  s = await contract.getSignature(1);
  console.log("Sig 1", s);
  s = await contract.getSignatureEthAmount(1);
  console.log("Eth 1", s);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
