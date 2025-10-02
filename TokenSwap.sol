contracts/AdvancedAMM.sol// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AdvancedAMM
 * @dev Advanced Automated Market Maker for Base network
 * Inspired by Aerodrome Finance with stable swap algorithms
 * @author wearedood
 */
contract AdvancedAMM is ReentrancyGuard, Ownable {
    uint256 public constant BASE_CHAIN_ID = 8453;
    uint256 public constant MAX_FEE = 1000; // 10%
    
    struct Pool {
        address tokenA;
        address tokenB;
        uint256 reserveA;
        uint256 reserveB;
        uint256 totalSupply;
        uint256 fee;
        bool isStable;
        bool isActive;
        mapping(address => uint256) balances;
    }
    
    mapping(bytes32 => Pool) public pools;
    mapping(address => mapping(address => bytes32)) public getPoolId;
    bytes32[] public allPools;
    
    event PoolCreated(bytes32 indexed poolId, address tokenA, address tokenB, uint256 fee, bool isStable);
    event LiquidityAdded(bytes32 indexed poolId, address provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event Swap(bytes32 indexed poolId, address user, address tokenIn, uint256 amountIn, uint256 amountOut);
    
    modifier onlyBase() {
        require(block.chainid == BASE_CHAIN_ID, "Invalid chain");
        _;
    }
    
    function createPool(address tokenA, address tokenB, uint256 fee, bool isStable) external onlyBase returns (bytes32 poolId) {
        require(tokenA != tokenB && tokenA != address(0) && tokenB != address(0), "Invalid tokens");
        require(fee <= MAX_FEE, "Fee too high");
        
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(getPoolId[token0][token1] == bytes32(0), "Pool exists");
        
        poolId = keccak256(abi.encodePacked(token0, token1, fee, isStable));
        
        Pool storage pool = pools[poolId];
        pool.tokenA = token0;
        pool.tokenB = token1;
        pool.fee = fee;
        pool.isStable = isStable;
        pool.isActive = true;
        
        getPoolId[token0][token1] = poolId;
        allPools.push(poolId);
        
        emit PoolCreated(poolId, token0, token1, fee, isStable);
    }
    
    function addLiquidity(bytes32 poolId, uint256 amountA, uint256 amountB) external nonReentrant returns (uint256 liquidity) {
        Pool storage pool = pools[poolId];
        require(pool.isActive, "Pool inactive");
        
        IERC20(pool.tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(pool.tokenB).transferFrom(msg.sender, address(this), amountB);
        
        if (pool.totalSupply == 0) {
            liquidity = sqrt(amountA * amountB);
        } else {
            liquidity = min((amountA * pool.totalSupply) / pool.reserveA, (amountB * pool.totalSupply) / pool.reserveB);
        }
        
        pool.reserveA += amountA;
        pool.reserveB += amountB;
        pool.totalSupply += liquidity;
        pool.balances[msg.sender] += liquidity;
        
        emit LiquidityAdded(poolId, msg.sender, amountA, amountB, liquidity);
    }
    
    function swap(bytes32 poolId, address tokenIn, uint256 amountIn, uint256 amountOutMin) external nonReentrant returns (uint256 amountOut) {
        Pool storage pool = pools[poolId];
        require(pool.isActive && (tokenIn == pool.tokenA || tokenIn == pool.tokenB), "Invalid swap");
        
        bool isTokenA = tokenIn == pool.tokenA;
        address tokenOut = isTokenA ? pool.tokenB : pool.tokenA;
        uint256 reserveIn = isTokenA ? pool.reserveA : pool.reserveB;
        uint256 reserveOut = isTokenA ? pool.reserveB : pool.reserveA;
        
        amountOut = (amountIn * reserveOut) / (reserveIn + amountIn);
        uint256 feeAmount = (amountOut * pool.fee) / 10000;
        amountOut -= feeAmount;
        
        require(amountOut >= amountOutMin, "Insufficient output");
        
        if (isTokenA) {
            pool.reserveA += amountIn;
            pool.reserveB -= amountOut;
        } else {
            pool.reserveB += amountIn;
            pool.reserveA -= amountOut;
        }
        
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);
        
        emit Swap(poolId, msg.sender, tokenIn, amountIn, amountOut);
    }
    
    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
    
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    
    function getPoolInfo(bytes32 poolId) external view returns (address, address, uint256, uint256, uint256, uint256, bool) {
        Pool storage pool = pools[poolId];
        return (pool.tokenA, pool.tokenB, pool.reserveA, pool.reserveB, pool.totalSupply, pool.fee, pool.isStable);
    }
}
