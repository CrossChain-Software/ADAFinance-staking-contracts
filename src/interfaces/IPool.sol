// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IPool {

     struct Deposit {
        // @dev token amount deposited
        uint256 tokenAmount;
        // @dev stake weight
        uint256 timestamp;
    }

    function getDeposit(address _user, uint256 _depositId) external view returns (Deposit memory);

    function getDeposits(address _user) external view returns (uint256[] memory, uint256[] memory);

    function getTotalStakedPerUser(address _user) external view returns (uint256);
    
    // function getIncentivesSupply() external view returns (uint256);
    
    // function getIncentivesRemaining() external view returns (uint256);
    
    // function getIncentiveLevels() external view returns (uint256);
    
    // function getDepositFee() external view returns (uint256);
    
    // function getWithdrawalFee() external view returns (uint256);
    
    // function getMinAmount() external view returns (uint256);
    
    // function getFeeDistribution() external view returns (uint256);
    
    // function getTotalStaked() external view returns (uint256);

    // function stake(uint256 _amount) external;

    // function unstake(uint256 _amount) external;

    // function calcRewards(uint256 _amount) external;

}
