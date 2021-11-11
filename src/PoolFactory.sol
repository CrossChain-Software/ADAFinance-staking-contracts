// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";
import "./Pool.sol";
import "./utils/Ownable.sol";

contract PoolFactory is Ownable, IPool {
    address internal owner;
    address internal avaxTokenAddress = "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z";

    struct PoolData {
        address poolToken;
        address poolAddress;
        uint256 incentivesSupply;
        uint256 incentivesRemaining;
        uint256 incentiveLevels;
        uint256 depositFee;
        uint256 withdrawalFee;
        uint256 minAmount;
        uint256 feeDistribution;
        uint256 totalStaked;
    }
    // this has to change, we need the tokenAddress => PoolData
    // or should it be poolAddress => PoolData?
    mapping (address => PoolData) internal poolAddressToData;
    mapping (address => address) public pools;

    event PoolRegistered(
        address indexed _by,
        address indexed poolToken,
        address indexed poolAddress
    );

    constructor() {
        owner = msg.sender;
    }

    function getPoolAddress (address _poolToken) public view returns (address) {
        return pools[_poolToken];
    }

    function getTotalStaked(address _poolAddress) public view returns (uint256) {
        return poolAddressToData[_poolAddress].totalStaked;
    }

    // need to test- never returned a data type like this before
    function getStakingPoolInfo(address _poolToken) public view returns (address) {
        require(_poolToken != address(0), "Pool not found!");
        
        address pool = pools[_poolToken];
        
        return PoolData({
            poolToken: pool._poolToken,
            poolAddress: pool.poolAddress,
            incentivesSupply: pool.incentivesSupply,
            incentivesRemaining: pool.incentivesRemaining,
            incentiveLevels: pool.incentiveLevels,
            depositFee: pool.depositFee,
            withdrawalFee: pool.withdrawalFee,
            minAmount: pool.minAmount,
            feeDistribution: pool.feeDistribution,
            totalStaked: pool.totalStaked
        });
    }

    function createStakingPool(uint256 _incentiveSupply, bytes32[] memory _incentiveLevels, uint256 _depositFee, uint256 _withdrawalFee, uint256 _minAmount, uint256[] memory _feeDistribution, bytes32 _poolName, address _poolToken) onlyOwner external virtual returns (bool) {

        IPool pool = new Pool(_poolToken, _incentiveSupply, _incentiveLevels, _depositFee, _withdrawalFee, _minAmount, _feeDistribution);
        
        // how do we create a new contract address and add it to the PoolData state + mapping?

        return pool; // i think this returns the contract address?
    }
}