// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Pool {
    bytes32 poolName;

    struct User {
        uint256 tokenAmount;
        Deposit[] deposits; // []
        DepositTimestamps[] timestamps;
        mapping (uint256 => mapping (uint256 => uint256)) depositTimestamps;
        // (1: {amount, timestamp}, 2: {amount, timestamp}, ...) depositTimestamps;
        // @ dev Holder deposits (depositId => timestamp)
        mapping (uint256 => uint256) depositIdsToTimestamps; 
    }

    mapping(address => User) public users;

    constructor(bytes32 _poolName) {
        poolName = _poolName;
    }

    function getUserDeposits(address _user) public view returns () {
        return users[_user];
    }

    function getUserDepositsLength(address _user) public view returns (uint256) {
        return users[_user].deposits.length;
    }

    function unclaimedRewards(address _user) public view returns (uint256) {
        return users[_user].unclaimedAmount;
    }

    // @dev Unstake tokens from the pool
    function withdraw(address _user, uint256 _amount) public { 
        require(users[_user].tokenAmount >= _amount);
        users[_user].tokenAmount -= _amount;
    }

}