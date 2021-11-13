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

    /// @dev Gets a single deposit
    /// @notice User storage design should be updated to search by depositId or user address- so you don't need both
    function getDeposit(address _user, uint256 _depositId) public view override returns (Deposit memory) {
        require(_depositId != 0x0);

        User memory user = users[_user];
        return user.deposits[_depositId];
    }

    /// @dev Gets the deposits and returns a tuple
    /// @return Solidity has limited types that you cant use for returns, so we use a tuple to return the tokenAmount and timestamp
    function getDeposits(address _user) public view override returns (uint256[] memory, uint256[] memory) {
        User memory user = users[_user];
        uint256[] memory tokenAmounts = new uint256[](user.deposits.length);
        uint256[] memory timestamps = new uint256[](user.deposits.length);

        for (uint i = 0; i < user.deposits.length; i++) {
            tokenAmounts[i] = user.deposits[i].tokenAmount;
            timestamps[i] = user.deposits[i].timestamp;
        }

        return (tokenAmounts, timestamps);
    }

    /// @dev Gets the total amount staked per user, uses a for loop to sum up all the deposits
    /// @notice Needs logic to take into account rewards
    function getTotalStakedPerUser(address _user) public view override returns (uint256) {
        User memory user = users[_user];
        uint256 total = 0;

        for (uint i = 0; i < user.deposits.length; i++) {
            total += user.deposits[i].tokenAmount;
        }

        return total;
    }

    /// @dev Allows owner to update the fees
    function updateFeeDistributions(uint256 _daoDistribution, uint256 _affiliateDistribution) public onlyOwner {
        require(daoDistribution + affiliateDistribution <= 100);

        daoDistribution = _daoDistribution;
        affiliateDistribution = _affiliateDistribution;
    }
    
    /// @dev Allows owner to update the fee addresses
    function updateFeeDistrbutionAddresses(address _daoAddress, address _affiliateAddress) public onlyOwner {
        require(msg.sender == owner());
        require(_daoAddress != address(0x0));
        require(_affiliateAddress != address(0x0));

        daoAddress = _daoAddress;
        affiliateAddress = _affiliateAddress;
    }

    /// @dev Stame the tokens for a new user
    /// @notice Needs logic to handle if the user has previously deposited
    function stake(address _user, uint256 _amount) public {
        require(_amount >= minAmount, "Staking amount must be greater than or equal to minAmount");
        require(users[_user].tokenAmount + _amount <= incentiveSupply);
        
        User storage user = users[_user];
        Deposit memory newDeposit = Deposit({tokenAmount: _amount, timestamp: block.timestamp});
        user.tokenAmount += _amount;
        user.deposits.push(newDeposit);
        poolTokenReserve += _amount;
    }

    /// @dev Unstake tokens from the pool
    function unstake(address _user, uint256 _amount, uint256 _depositId) public { 
        require(_amount > 0, "Zero amount");
        
        User storage user = users[_user];
        Deposit storage stakeDeposit = user.deposits[_depositId];
        
        require(stakeDeposit.tokenAmount >= _amount, "Not enough tokens to unstake");

        processRewards(_user, stakeDeposit.tokenAmount, stakeDeposit.timestamp);

        users[_user].tokenAmount -= _amount;
    }

    /// @dev Calculates the total rewards a person has earned, >/< 90 days
    function processRewards(address _user, uint256 _tokenAmount, uint256 _timestamp) internal {
        require(_tokenAmount > 0, "Zero amount");
        require(_timestamp > 0, "Invalid timestamp");
        require(_timestamp <= block.timestamp, "Timestamp must be in the past");
        require(users[_user].tokenAmount >= _tokenAmount, "Not enough tokens to process rewards");
        
        // if unstaking before 90 days, they only get tokenAmount + 15% APR
        // calc this when they withdraw to save on gas
        if ((block.timestamp - _timestamp) > 90) {
            // 20% APR
            calculateAPR(_tokenAmount, 20);
        } else {
            // 15% APR
            calculateAPR(_tokenAmount, 15);
        }
    }

    function calculateAPR(uint256 _tokenAmount, uint256 _percentage) internal virtual returns (uint256) {

    }
}