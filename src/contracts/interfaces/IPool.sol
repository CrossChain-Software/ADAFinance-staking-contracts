// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IPool {

    function getIncentivesSupply() {
        return incentivesSupply;
    }
    
    function getIncentivesRemaining() {
        return incentivesRemaining;
    }
    
    function getIncentiveLevels() {
        return incentiveLevels;
    }
    
    function getDepositFee() {
        return depositFee;
    }
    
    function getWithdrawalFee() {
        return withdrawalFee;
    }
    
    function getMinAmount() {
        return minAmount;
    }
    
    function getFeeDistribution() {
        return feeDistribution;
    }
    
    function getTotalStaked() {
        return totalStaked;
    }

}
