const hre = require("hardhat");

async function main() {
  const ParmarToken = await hre.ethers.getContractFactory("ParmarToken");
  const parmarToken = await ParmarToken.deploy(100000000, 50);

  await parmarToken.deployed();

  console.log("Parmar Token deployed: ", parmarToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
