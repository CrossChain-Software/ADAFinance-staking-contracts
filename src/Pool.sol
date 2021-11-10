// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";


contract Pool is IPool {

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
        user2Address = {...}, 
        ...
    ]
    */
    struct User {
        // @dev Total tokens in the pool
        uint256 tokenAmount; 
        // @dev deposits = [{tokenAmount, timestamp}, {...}, ...]
        Deposit[] deposits;  
    }
   
    mapping(address => User) public users;


    constructor(address _poolToken) {}

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

    function getTotalStakedPerUser(address _user) public view returns (uint256) {
        User memory user = users[_user];
        uint256 total = 0;

        for (uint i = 0; i < user.deposits.length; i++) {
            total += user.deposits[i].tokenAmount;
        }

        return total;
    }

    // @dev Unstake tokens from the pool
    function unstake(address _user, uint256 _amount) public { 
        require(users[_user].tokenAmount >= _amount);
        users[_user].tokenAmount -= _amount;
        // need to transfer funds to user
    }
    
}