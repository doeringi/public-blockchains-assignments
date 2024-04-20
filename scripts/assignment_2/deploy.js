const hre = require("hardhat");

async function main() {
  // Compile the contract
  await hre.run("compile");

  // Get the Contract Factory
  const MyQuiz = await hre.ethers.getContractFactory("MyQuiz");

  // Define questions and answers
  const questions = [
    "Does water boil at 100 degrees Celsius?",
    "Is the earth flat?",
    "Do humans have more than 4 senses?",
    "Is venus the closest planet to the sun?",
    "Does light travel faster than sound?",
  ];

  const answers = [true, false, true, false, true];

  // Deploy the contract with the initial questions and answers
  const myQuiz = await MyQuiz.deploy(questions, answers);

  await myQuiz.deployed();

  console.log("MyQuiz deployed to:", myQuiz.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
