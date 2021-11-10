// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";


contract Pool is IPool {

    struct User {
        uint256 tokenAmount; // total tokens in the pool
        Deposit[] deposits;  // deposits = [{tokenAmount, timestamp}, ...]
    }
    mapping(address => User) public users;

    /**
    users = [
        user1Address = {
            tokenAmount: 100,
            deposits: [
                {tokenAmount: 10, timestamp: 100},
                {tokenAmount: 20, timestamp: 200},
                {tokenAmount: 30, timestamp: 300},
            ]
        },
    ]
    */

    constructor() {}

    function getDeposit(address _user, uint256 _depositId) public view returns (Deposit memory) {
        require(_depositId != 0x0);
        User memory user = users[_user];
        return user.deposits[_depositId];
    }

    function getDeposits(address _user) public view returns (uint256[] memory, uint256[] memory) {
        User memory user = users[_user];

        /// user[userAddress].deposits -> convert to tuple to return, cant return structs
        uint256[] memory tokenAmounts = new uint256[](user.deposits.length);
        uint256[] memory timestamps = new uint256[](user.deposits.length);
        for (uint i = 0; i < user.deposits.length; i++) {
            tokenAmounts[i] = user.deposits[i].tokenAmount;
            timestamps[i] = user.deposits[i].timestamp;
        }

        return (tokenAmounts, timestamps);
    }

    // @dev Unstake tokens from the pool
    function unstake(address _user, uint256 _amount) public { 
        require(users[_user].tokenAmount >= _amount);
        users[_user].tokenAmount -= _amount;
        // need to transfer funds to user
    }
    
}