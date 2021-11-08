// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IPool.sol";
import "./Pool.sol";
import "../utils/Ownable.sol";

contract PoolFactory is Ownable, IPool {
    address owner;
    uint256 baseMod = 100;

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
    mapping (bytes32 => mapping (address => PoolData)) internal poolNameToAddresses;
    mapping (address => address) public pools;

    constructor() {
        owner = msg.sender; // is this exploitable?
    }

    function getPoolAddress (bytes32 _poolToken) public view returns (address) {
        return pools[_poolToken];
    }

    function getStakingPoolInfo(bytes32 _poolName, address _poolToken) public view returns (address) {
        address poolAddress = pools[_pooToken];
        require(poolAddress != address(0), "pool not found!");

        
        return PoolData({
            poolToken: _poolToken,
            poolAddress: poolAddress,
            incentivesSupply: poolAddress.getIncentivesSupply(),
            incentivesRemaining: poolAddress.getIncentivesRemaining(),
            incentiveLevels: poolAddress.getIncentiveLevels(),
            depositFee: poolAddress.getDepositFee(),
            withdrawalFee: poolAddress.getWithdrawalFee(),
            minAmount: poolAddress.getMinAmount(),
            feeDistribution: poolAddress.getFeeDistribution(),
            totalStaked: poolAddress.getTotalStaked()
        });
    }

    function createStakingPool(uint256 _incentiveSupply, bytes32[] memory _incentiveLevels, uint256 _depositFee, uint256 _withdrawalFee, uint256 _minAmount, uint256[] memory _feeDistribution, bytes32 _poolName) onlyOwner external virtual returns (bool) {
        poolName = _poolName;
        new Pool(poolName, _incentiveSupply, _incentiveLevels, _depositFee, _withdrawalFee, _minAmount, _feeDistribution);
        // how do we get the deployed address?
        poolNameToAddresses[_poolName] = {
            poolToken: poolToken,
            poolAddress: poolAddress,
            incentivesSupply: _incentiveSupply,
            incentivesRemaining: _incentiveSupply, // how do we calculate incestives remaining?
            incentiveLevels: _incentiveLevels,
            depositFee: _depositFee,
            withdrawalFee: _withdrawalFee,
    }

    return 

}