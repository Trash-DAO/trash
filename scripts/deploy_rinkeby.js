const hre = require("hardhat");

async function main() {
  const Faucet = "0x5a3b5aD2397A92a6Ff417489A24B16edEc7bC418";
  // const NFTFaucet = await hre.ethers.getContractFactory("NftFaucet");
  // const nftFaucet = await NFTFaucet.deploy();
  // console.log("NFT Faucet deployed to:", nftFaucet.address);
  // const TrashDAO = await ethers.getContractFactory("TrashDAO");
  // trashDAO = await upgrades.deployProxy(TrashDAO, [], {
  //   initializer: "initialize",
  //   unsafeAllowCustomTypes: true,
  // });
  // console.log("TrashDAO deployed to:", trashDAO.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
