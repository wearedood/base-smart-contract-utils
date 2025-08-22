// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BaseUtils
 * @dev Essential utilities for Base blockchain development
 * @author wearedood
 */
contract BaseUtils {
    // Base network constants
    uint256 public constant BASE_CHAIN_ID = 8453;
    address public constant BASE_BRIDGE = 0x3154Cf16ccdb4C6d922629664174b904d80F2C35;
    
    // Events
    event UtilityExecuted(address indexed user, string indexed action, uint256 value);
    event EmergencyWithdraw(address indexed token, uint256 amount);
    
    // Errors
    error InvalidChainId();
    error InsufficientBalance();
    error TransferFailed();
    error InvalidAddress();
    
    modifier onlyBase() {
        require(block.chainid == BASE_CHAIN_ID, "Invalid chain");
        _;
    }
    
    /**
     * @dev Get current Base network information
     */
    function getBaseNetworkInfo() external view returns (
        uint256 chainId,
        address bridge,
        uint256 blockNumber,
        uint256 timestamp
    ) {
        return (
            BASE_CHAIN_ID,
            BASE_BRIDGE,
            block.number,
            block.timestamp
        );
    }
    
    /**
     * @dev Batch transfer ETH to multiple addresses
     */
    function batchTransferETH(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) external payable onlyBase {
        require(recipients.length == amounts.length, "Array length mismatch");
        
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        
        require(msg.value >= totalAmount, "Insufficient balance");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid address");
            
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "Transfer failed");
            
            emit UtilityExecuted(recipients[i], "batch_transfer", amounts[i]);
        }
    }
    
    /**
     * @dev Calculate gas cost for Base transactions
     */
    function calculateGasCost(
        uint256 gasUsed,
        uint256 gasPrice
    ) external pure returns (uint256) {
        return gasUsed * gasPrice;
    }
    
    /**
     * @dev Get contract balance
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Receive function to accept ETH
     */
    receive() external payable {
        emit UtilityExecuted(msg.sender, "deposit", msg.value);
    }
}
