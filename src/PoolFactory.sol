// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";
import "./Pool.sol";
import "./utils/Ownable.sol";

contract PoolFactory is Ownable {
    address internal owner;
    address internal avaxTokenAddress = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;

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
    /// @dev poolAddress => PoolData
    mapping (address => PoolData) internal pools;
    
    /// @dev tokenAddress => poolAdddress => PoolData
    mapping (address => mapping(address => PoolData)) poolsByToken;

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
        return pools[_poolAddress].totalStaked;
    }

    // need to test- never returned a data type like this before
    function getStakingPoolInfo(address _poolAddress) public view returns (address) {
        require(_poolAddress != address(0), "Pool not found!");];


        return PoolData({
            poolToken: pools[_poolAddress].poolToken,
            poolAddress: pools[_poolAddress].poolAddress,
            incentivesSupply: pools[_poolAddress].incentivesSupply,
            incentivesRemaining: pools[_poolAddress].incentivesRemaining,
            incentiveLevels: pools[_poolAddress].incentiveLevels,
            depositFee: pools[_poolAddress].depositFee,
            withdrawalFee: pools[_poolAddress].withdrawalFee,
            minAmount: pools[_poolAddress].minAmount,
            feeDistribution: pools[_poolAddress].feeDistribution,
            totalStaked: pools[_poolAddress].totalStaked
        });
    }

    function createStakingPool(uint256 _incentiveSupply, bytes32[] memory _incentiveLevels, uint256 _depositFee, uint256 _withdrawalFee, uint256 _minAmount, uint256[] memory _feeDistribution, bytes32 _poolName, address _poolToken) onlyOwner external virtual returns (bool) {

        IPool pool = new Pool(_poolToken, _incentiveSupply, _incentiveLevels, _depositFee, _withdrawalFee, _minAmount, _feeDistribution);
        
        // how do we create a new contract address and add it to the PoolData state + mapping?

        return pool; // i think this returns the contract address?
    }
}