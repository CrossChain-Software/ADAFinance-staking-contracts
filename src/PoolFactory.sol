// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";
import "./Pool.sol";
import "./utils/Ownable.sol";

contract PoolFactory is Ownable {
    address internal constant avaxTokenAddress = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    address public immutable adafiTokenAddress;
    
    uint16 baseMod = 1000;
    uint256 daoDistribution = 20 / baseMod;
    address daoAddress; 
    uint256 affiliateDistribution = 30 / baseMod; 
    address affiliateAddress;

    struct PoolData {
        address poolToken;
        address poolAddress;
        uint256 incentivesSupply;
        uint256 incentivesRemaining;
        uint256 level1Rewards;
        uint256 level2Rewards;
        uint256 depositFee;
        uint256 withdrawalFee;
        uint256 minAmount;
        uint256 daoDistribution;
        uint256 affiliateDistribution;
        uint256 totalStaked;
    }

    /// @dev poolAddress => PoolData
    mapping (address => PoolData) internal pools;
    
    /// @dev tokenAddress => poolAdddress => PoolData
    mapping (address => mapping(address => PoolData)) poolsByToken;

    event PoolRegistered(
        address indexed _by,
        address indexed poolToken,
        address indexed poolAddress
    );

    constructor(address _adafiTokenAddress) {
        require(_adafiTokenAddress != address(0));
        adafiTokenAddress = _adafiTokenAddress;
    }

    function getPoolAddress (address _poolToken) public view returns (address) {
        return pools[_poolToken].poolAddress;
    }

    function getTotalStaked(address _poolAddress) public view returns (uint256) {
        return pools[_poolAddress].totalStaked;
    }

    // need to test- never returned a data type like this before
    function getStakingPoolInfo(address _poolAddress) public view returns (PoolData memory) {
        require(_poolAddress != address(0), "Pool not found!");


        return PoolData({
            poolToken: pools[_poolAddress].poolToken,
            poolAddress: pools[_poolAddress].poolAddress, // we can drop this and use it as the key in a mapping- mapping (poolAddress => PoolData)
            incentivesSupply: pools[_poolAddress].incentivesSupply,
            incentivesRemaining: pools[_poolAddress].incentivesRemaining,
            level1Rewards: pools[_poolAddress].level1Rewards,
            level2Rewards: pools[_poolAddress].level2Rewards,
            depositFee: pools[_poolAddress].depositFee,
            withdrawalFee: pools[_poolAddress].withdrawalFee,
            minAmount: pools[_poolAddress].minAmount,
            daoDistribution: pools[_poolAddress].daoDistribution,
            affiliateDistribution: pools[_poolAddress].affiliateDistribution,
            totalStaked: pools[_poolAddress].totalStaked
        });
    }

    function createStakingPool(address _poolToken, uint256 _incentiveSupply, uint256 _level1Rewards, uint256 _level2Rewards, uint256 _depositFee, uint256 _withdrawalFee, uint256 _minAmount, uint256 _daoDistribution, uint256 _affiliateDistribution) onlyOwner external virtual {

        IPool pool = new Pool(_poolToken, _incentiveSupply, _level1Rewards, _level2Rewards, _depositFee, _withdrawalFee, _minAmount, _daoDistribution, _affiliateDistribution);
        
        // registerPool(address(pool)); // we need to pass in the struct
        pools[address(pool)] = pool;

        emit PoolRegistered(msg.sender, _poolToken, address(pool));
    }

    function registerPool(address _pool) public onlyOwner {
        require(_pool != address(0), "Pool not found!");

        // pools[_pool].poolToken = poolToken;
        // pools[_pool].poolAddress = _pool;
        // pools[_pool].incentivesSupply = 0;
        // pools[_pool].incentivesRemaining = 0;
        // pools[_pool].level1Rewards = 0;
        // pools[_pool].level2Rewards = 0;
        // pools[_pool].depositFee = 0;
        // pools[_pool].withdrawalFee = 0;
        // pools[_pool].minAmount = 0;
        // pools[_pool].daoDistribution = 0;
        // pools[_pool].affiliateDistribution = 0;
        // pools[_pool].totalStaked = 0;
    }
}