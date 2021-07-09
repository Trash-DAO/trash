/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");
require("@tenderly/hardhat-tenderly");
require("dotenv").config();

//
// Select the network you want to deploy to here:
//
const defaultNetwork = "rinkeby";

function mnemonic() {
  try {
    return fs.readFileSync("./mnemonic.txt").toString().trim();
  } catch (e) {
    if (defaultNetwork !== "localhost") {
      console.log(
        "☢️ WARNING: No mnemonic file created for a deploy account. Try `yarn run generate` and then `yarn run account`."
      );
    }
  }
  return "";
}

module.exports = {
  defaultNetwork,
  networks: {
    // hardhat: {
    //   gas: 12000000,
    //   blockGasLimit: 0x1fffffffffffff,
    //   allowUnlimitedContractSize: true,
    //   timeout: 1800000,
    // },
    hardhat: {
      forking: {
        url: `https://mainnet.infura.io/v3/${process.env.INFURA}`,
        blockNumber: 12774732,
      },
    },
    localhost: {
      url: "http://localhost:8545",
      allowUnlimitedContractSize: true,
      timeout: 1800000,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA}`, //<---- YOUR INFURA ID! (or it won't work)
      accounts: [process.env.KEY],
      gasPrice: 4000000000,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA}`,
      // accounts: [process.env.KEY],
      accounts: [],
      gasPrice: 14000000000,
    },
    ropsten: {
      url: "https://ropsten.infura.io/v3/", //<---- YOUR INFURA ID! (or it won't work)
      accounts: [],
      gasPrice: 15000000000,
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN,
    url: "https://api.etherscan.com/",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.2",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 2000000,
  },
};
