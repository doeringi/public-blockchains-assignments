/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    numa: {
      url: process.env.NOT_UNIMA_URL_1,
      chainId: 1337,
      accounts: [process.env.METAMASK_1_PRIVATE_KEY],
    },
  },
};
