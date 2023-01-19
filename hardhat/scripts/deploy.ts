import { ethers } from "hardhat";

async function main() {

  const nftdropContract = await ethers.getContractFactory("nftdrop");

  // deploy the contracts
  const deployednftdropContract = await nftdropContract.deploy(
  );
  
  await deployednftdropContract.deployed();
  
  // print the address of the deployed contract
  console.log(
  "NFT Collection Address:"
  ,deployednftdropContract.address
    );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
