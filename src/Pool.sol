// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";
import "./utils/Ownable.sol";


contract Pool is IPool, Ownable {

    struct User {
        /// @dev Total tokens in the pool
        uint256 tokenAmount; 
        /// @dev deposits = [{tokenAmount, timestamp}, {...}, ...]
        Deposit[] deposits;  
    }

    mapping(address => User) public users;
    address poolToken;
    uint256 poolTokenReserve;
    uint256 incentiveSupply;
    uint256 level1Rewards;
    uint256 level2Rewards;
    uint256 depositFee;
    uint256 withdrawalFee;
    uint256 minAmount;
    uint256 daoDistribution;
    address daoAddress; 
    uint256 affiliateDistribution; 
    address affiliateAddress;


    constructor(address _poolToken, uint256 _incentiveSupply, uint256 _level1Rewards, uint256 _level2Rewards, uint256 _depositFee, uint256 _withdrawalFee, uint256 _minAmount, uint256 _daoDistribution, uint256 _affiliateDistribution) {
        poolToken = _poolToken;
        incentiveSupply = _incentiveSupply;
        level1Rewards = _level1Rewards;
        level2Rewards = _level2Rewards;
        depositFee = _depositFee;
        withdrawalFee = _withdrawalFee;
        minAmount = _minAmount;
        daoDistribution = _daoDistribution;
        affiliateDistribution = _affiliateDistribution;
    }

    function getPoolToken() public view returns (address) {
        return poolToken;
    }

    function getDeposit(address _user, uint256 _depositId) public view override returns (Deposit memory) {
        require(_depositId != 0x0);
        User memory user = users[_user];
        return user.deposits[_depositId];
    }

    function getDeposits(address _user) public view override returns (uint256[] memory, uint256[] memory) {
        User memory user = users[_user];

        /// @dev user[userAddress].deposits -> convert to tuple to return, cant return structs
        uint256[] memory tokenAmounts = new uint256[](user.deposits.length);
        uint256[] memory timestamps = new uint256[](user.deposits.length);
        for (uint i = 0; i < user.deposits.length; i++) {
            tokenAmounts[i] = user.deposits[i].tokenAmount;
            timestamps[i] = user.deposits[i].timestamp;
        }

        return (tokenAmounts, timestamps);
    }

    function getTotalStakedPerUser(address _user) public view override returns (uint256) {
        User memory user = users[_user];
        uint256 total = 0;

        for (uint i = 0; i < user.deposits.length; i++) {
            total += user.deposits[i].tokenAmount;
        }

        return total;
    }


    function updateFeeDistributions(uint256 _daoDistribution, uint256 _affiliateDistribution) public onlyOwner {
        require(daoDistribution + affiliateDistribution <= 100);
        daoDistribution = _daoDistribution;
        affiliateDistribution = _affiliateDistribution;
    }

    function updateFeeAddresses(address _daoAddress, address _affiliateAddress) public onlyOwner {
        require(daoDistribution + affiliateDistribution <= 100);
        daoAddress = _daoAddress;
        affiliateAddress = _affiliateAddress;
    }
    
    function updateFeeDistrbutionAddresses(address _daoAddress, address _affiliateAddress) public onlyOwner {
        require(msg.sender == owner());
        require(_daoAddress != address(0x0));
        require(_affiliateAddress != address(0x0));
        daoAddress = _daoAddress;
        affiliateAddress = _affiliateAddress;
    }

    function stake(address _user, uint256 _amount) public {
        require(_amount >= minAmount, "Staking amount must be greater than or equal to minAmount");
        require(users[_user].tokenAmount + _amount <= incentiveSupply);
        
        User storage user = users[_user];
        Deposit memory newDeposit = Deposit({tokenAmount: _amount, timestamp: block.timestamp});
        user.tokenAmount += _amount;
        user.deposits.push(newDeposit);
        
        poolTokenReserve += _amount;
    }

    // @dev Unstake tokens from the pool
    function unstake(address _user, uint256 _amount) public { 
        require(users[_user].tokenAmount >= _amount);
        users[_user].tokenAmount -= _amount;
        // need to transfer funds to user
    }
}