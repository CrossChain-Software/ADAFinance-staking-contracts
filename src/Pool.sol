// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPool.sol";


contract Pool is IPool {

    struct User {
        uint256 tokenAmount;
        Deposit[] deposits; 
    }
    mapping(address => User) public users;


    constructor() {}

    function getDeposit(address _user, uint256 _depositId) public view returns (Deposit memory) {
        require(_depositId != 0x0);
        User memory user = users[_user];
        return user.deposits[_depositId];
    }

    // @dev Unstake tokens from the pool
    function unstake(address _user, uint256 _amount) public { 
        require(users[_user].tokenAmount >= _amount);
        users[_user].tokenAmount -= _amount;
        // need to transfer funds to user
    }
    
}