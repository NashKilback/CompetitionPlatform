const { ethers } = require("hardhat");

async function main() {
  console.log("🏆 Deploying Competition Scoring Platform...");
  
  // Get the ContractFactory and Signers here.
  const CompetitionPlatform = await ethers.getContractFactory("CompetitionPlatform");
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy the contract
  const competitionPlatform = await CompetitionPlatform.deploy();
  await competitionPlatform.waitForDeployment();

  const contractAddress = await competitionPlatform.getAddress();
  console.log("✅ CompetitionPlatform deployed to:", contractAddress);
  
  console.log("\n📋 Deployment Summary:");
  console.log("=".repeat(50));
  console.log(`Contract Address: ${contractAddress}`);
  console.log(`Deployer: ${deployer.address}`);
  console.log(`Network: ${network.name}`);
  console.log("=".repeat(50));
  
  console.log("\n🔗 Verification Command:");
  console.log(`npx hardhat verify --network ${network.name} ${contractAddress}`);
  
  console.log("\n✨ Contract deployed successfully!");
  console.log("You can now interact with it on Sepolia Etherscan:");
  console.log(`https://sepolia.etherscan.io/address/${contractAddress}`);

  return contractAddress;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });