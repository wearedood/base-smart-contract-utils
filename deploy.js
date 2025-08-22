// Base Mainnet Deployment Script for BaseUtils Contract
// This script deploys the BaseUtils contract to Base mainnet

const { ethers } = require('hardhat');
const fs = require('fs');
const path = require('path');

// Base network configuration
const BASE_CHAIN_ID = 8453;
const BASE_RPC_URL = 'https://mainnet.base.org';
const BASE_BRIDGE = '0x3154Cf16ccdb4C6d922629664174b904d80F2C35';

async function main() {
  console.log('🚀 Starting BaseUtils deployment to Base mainnet...');
  console.log('=' .repeat(50));
  
  // Verify network
  const network = await ethers.provider.getNetwork();
  console.log(`📡 Connected to network: ${network.name} (Chain ID: ${network.chainId})`);
  
  if (network.chainId !== BASE_CHAIN_ID) {
    throw new Error(`❌ Wrong network! Expected Base (${BASE_CHAIN_ID}), got ${network.chainId}`);
  }
  
  // Get deployer account
  const [deployer] = await ethers.getSigners();
  const deployerBalance = await deployer.getBalance();
  
  console.log(`👤 Deployer address: ${deployer.address}`);
  console.log(`💰 Deployer balance: ${ethers.utils.formatEther(deployerBalance)} ETH`);
  
  if (deployerBalance.lt(ethers.utils.parseEther('0.01'))) {
    throw new Error('❌ Insufficient balance for deployment');
  }
  
  // Get contract factory
  console.log('📦 Getting BaseUtils contract factory...');
  const BaseUtils = await ethers.getContractFactory('BaseUtils');
  
  // Estimate gas
  const deploymentData = BaseUtils.getDeployTransaction();
  const gasEstimate = await ethers.provider.estimateGas(deploymentData);
  const gasPrice = await ethers.provider.getGasPrice();
  const deploymentCost = gasEstimate.mul(gasPrice);
  
  console.log(`⛽ Estimated gas: ${gasEstimate.toString()}`);
  console.log(`💸 Estimated cost: ${ethers.utils.formatEther(deploymentCost)} ETH`);
  
  // Deploy contract
  console.log('🔨 Deploying BaseUtils contract...');
  const baseUtils = await BaseUtils.deploy({
    gasLimit: gasEstimate.mul(120).div(100), // 20% buffer
    gasPrice: gasPrice
  });
  
  console.log(`📄 Transaction hash: ${baseUtils.deployTransaction.hash}`);
  console.log('⏳ Waiting for deployment confirmation...');
  
  await baseUtils.deployed();
  
  console.log('✅ BaseUtils deployed successfully!');
  console.log(`📍 Contract address: ${baseUtils.address}`);
  
  // Verify deployment
  console.log('🔍 Verifying deployment...');
  const deployedCode = await ethers.provider.getCode(baseUtils.address);
  if (deployedCode === '0x') {
    throw new Error('❌ Contract deployment failed - no code at address');
  }
  
  // Test contract functionality
  console.log('🧪 Testing contract functionality...');
  try {
    const networkInfo = await baseUtils.getBaseNetworkInfo();
    console.log(`✅ Base Chain ID: ${networkInfo.chainId.toString()}`);
    console.log(`✅ Base Bridge: ${networkInfo.bridge}`);
    console.log(`✅ Block Number: ${networkInfo.blockNumber.toString()}`);
    
    const balance = await baseUtils.getBalance();
    console.log(`✅ Contract Balance: ${ethers.utils.formatEther(balance)} ETH`);
  } catch (error) {
    console.log(`⚠️  Contract test failed: ${error.message}`);
  }
  
  // Save deployment info
  const deploymentInfo = {
    contractName: 'BaseUtils',
    address: baseUtils.address,
    transactionHash: baseUtils.deployTransaction.hash,
    blockNumber: baseUtils.deployTransaction.blockNumber,
    gasUsed: gasEstimate.toString(),
    gasPrice: gasPrice.toString(),
    deploymentCost: ethers.utils.formatEther(deploymentCost),
    network: 'base-mainnet',
    chainId: network.chainId,
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    baseConstants: {
      chainId: BASE_CHAIN_ID,
      bridge: BASE_BRIDGE,
      rpcUrl: BASE_RPC_URL
    }
  };
  
  // Write deployment info to file
  const deploymentsDir = path.join(__dirname, 'deployments');
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir, { recursive: true });
  }
  
  const deploymentFile = path.join(deploymentsDir, 'base-mainnet.json');
  fs.writeFileSync(deploymentFile, JSON.stringify(deploymentInfo, null, 2));
  
  console.log('=' .repeat(50));
  console.log('🎉 Deployment completed successfully!');
  console.log(`📁 Deployment info saved to: ${deploymentFile}`);
  console.log('=' .repeat(50));
  
  return deploymentInfo;
}

// Execute deployment
if (require.main === module) {
  main()
    .then((info) => {
      console.log('✅ Deployment script completed');
      process.exit(0);
    })
    .catch((error) => {
      console.error('❌ Deployment failed:', error.message);
      process.exit(1);
    });
}

module.exports = main;
