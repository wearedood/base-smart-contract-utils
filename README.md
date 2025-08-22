# Base Smart Contract Utils

Essential smart contract utilities and helpers for Base blockchain development, including deployment scripts, testing frameworks, and common contract patterns.

## 🚀 Features

- **Deployment Scripts**: Automated deployment for Base mainnet and testnet
- **Testing Framework**: Comprehensive test suites with Hardhat
- **Contract Templates**: Ready-to-use smart contract patterns
- **Gas Optimization**: Optimized contracts for Base's low-cost environment
- **Security Audited**: Battle-tested utility functions

## 📚 Contract Library

### Core Utilities
- `BaseUtils.sol` - Essential utility functions for Base development
- `SafeMath.sol` - Overflow protection (for older Solidity versions)
- `Ownable.sol` - Access control patterns
- `Pausable.sol` - Emergency stop functionality
- `ReentrancyGuard.sol` - Protection against reentrancy attacks

### DeFi Utilities
- `TokenUtils.sol` - ERC20 token helper functions
- `LPUtils.sol` - Liquidity pool management utilities
- `YieldUtils.sol` - Yield farming and staking helpers
- `PriceOracle.sol` - Price feed integrations

### NFT Utilities
- `NFTUtils.sol` - ERC721/ERC1155 helper functions
- `MetadataUtils.sol` - On-chain metadata management
- `RoyaltyUtils.sol` - EIP-2981 royalty implementations

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/wearedood/base-smart-contract-utils.git
cd base-smart-contract-utils

# Install dependencies
npm install

# Install Hardhat (if not already installed)
npm install --save-dev hardhat
```

## 🔧 Configuration

Create a `.env` file:

```env
# Base Network Configuration
BASE_MAINNET_RPC=https://mainnet.base.org
BASE_TESTNET_RPC=https://goerli.base.org

# Private Keys (use test keys only!)
PRIVATE_KEY=your_private_key_here
TESTNET_PRIVATE_KEY=your_testnet_private_key

# API Keys
BASESCAN_API_KEY=your_basescan_api_key
INFURA_API_KEY=your_infura_key
ALCHEMY_API_KEY=your_alchemy_key
```

## 📝 Usage Examples

### Deploying Contracts

```bash
# Deploy to Base testnet
npx hardhat run scripts/deploy.js --network base-testnet

# Deploy to Base mainnet
npx hardhat run scripts/deploy.js --network base-mainnet

# Verify contract on BaseScan
npx hardhat verify --network base-mainnet DEPLOYED_CONTRACT_ADDRESS
```

### Using BaseUtils in Your Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BaseUtils.sol";

contract MyContract is BaseUtils {
    function myFunction() external {
        // Use utility functions
        require(isValidAddress(msg.sender), "Invalid address");
        
        uint256 fee = calculateFee(amount, 250); // 2.5% fee
        
        // Safe transfer with gas optimization
        safeTransferETH(recipient, amount);
    }
}
```

### Testing

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/BaseUtils.test.js

# Run tests with gas reporting
npx hardhat test --gas-report

# Run coverage
npx hardhat coverage
```

## 📈 Gas Optimization

All contracts are optimized for Base's low-cost environment:

- Efficient storage patterns
- Minimal external calls
- Optimized loops and conditionals
- Assembly optimizations where safe

### Gas Usage Examples

| Function | Gas Cost | Description |
|----------|----------|-------------|
| `safeTransferETH` | ~2,300 | Optimized ETH transfer |
| `calculateFee` | ~500 | Fee calculation |
| `isValidAddress` | ~200 | Address validation |

## 🔒 Security Features

- **Reentrancy Protection**: All state-changing functions protected
- **Overflow Protection**: SafeMath integration for older Solidity
- **Access Control**: Role-based permissions
- **Emergency Stops**: Pausable functionality
- **Input Validation**: Comprehensive parameter checking

## 🧪 Testing Suite

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# Fuzz testing
npm run test:fuzz

# Security tests
npm run test:security
```

## 🚀 Deployment Networks

### Supported Networks
- Base Mainnet (Chain ID: 8453)
- Base Goerli Testnet (Chain ID: 84531)
- Base Sepolia Testnet (Chain ID: 84532)

### Contract Addresses

#### Base Mainnet
- BaseUtils: `0x...` (TBD)
- TokenUtils: `0x...` (TBD)

#### Base Testnet
- BaseUtils: `0x...` (TBD)
- TokenUtils: `0x...` (TBD)

## 📄 API Reference

### BaseUtils.sol

#### Functions

```solidity
function safeTransferETH(address to, uint256 amount) external
function calculateFee(uint256 amount, uint256 basisPoints) pure returns (uint256)
function isValidAddress(address addr) pure returns (bool)
function getChainId() view returns (uint256)
function getCurrentTimestamp() view returns (uint256)
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

### Development Guidelines
- Follow Solidity style guide
- Add comprehensive tests
- Document all functions
- Optimize for gas efficiency
- Include security considerations

## 🗺️ Roadmap

- [ ] Advanced DeFi utilities
- [ ] Cross-chain bridge helpers
- [ ] DAO governance utilities
- [ ] Advanced NFT features
- [ ] Layer 2 optimizations
- [ ] Formal verification

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Base team for the excellent L2 infrastructure
- OpenZeppelin for security patterns
- Hardhat team for development tools
- Ethereum community for standards

## 📞 Support

- Documentation: [docs.example.com](https://docs.example.com)
- Issues: [GitHub Issues](https://github.com/wearedood/base-smart-contract-utils/issues)
- Discord: [Join our community](https://discord.gg/example)
- Email: dev@example.com

---

**Building the future of Base development** 🚀
