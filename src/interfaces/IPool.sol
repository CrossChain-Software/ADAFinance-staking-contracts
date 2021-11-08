// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IPool {

    function getIncentivesSupply() external view returns (uint256);
    
    function getIncentivesRemaining() external view returns (uint256);
    
    function getIncentiveLevels() external view returns (uint256);
    
    function getDepositFee() external view returns (uint256);
    
    function getWithdrawalFee() external view returns (uint256);
    
    function getMinAmount() external view returns (uint256);
    
    function getFeeDistribution() external view returns (uint256);
    
    function getTotalStaked() external view returns (uint256);

}
