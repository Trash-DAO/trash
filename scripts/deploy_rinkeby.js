const hre = require("hardhat");

async function main() {
  const TrashDAO = await hre.ethers.getContractFactory("TrashDAO");
  const trashDAO = await TrashDAO.deploy();

  console.log("TrashDAO deployed to:", trashDAO.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
