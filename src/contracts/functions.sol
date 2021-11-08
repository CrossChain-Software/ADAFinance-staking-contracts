ADAFI Token Contract
Standard ERC20 Token Contract
Factory Contract
Contract to initiate the staking pool

getStakingPoolAddress()

createStakingPool(incentiveSupply, incentiveLevels, depositFee,withdrawalFee, minAmount, feeDistribution) onlyAdmin

getOwnersWallet() returns(address) {}

getPoolInfo() returns (incentiveSupply, incentivesRemaining, incentiveLevels, depositFee, withdrawalFee, minAmount, feeDistribution, totalStaked)

struct Staker {
        // @dev Total staked amount
        uint256 tokenAmount;
        // @dev Total weight
        uint256 totalWeight;
        // @dev Auxiliary variable for yield calculation
        uint256 subYieldRewards;
        // @dev Auxiliary variable for vault rewards calculation
        uint256 subVaultRewards;
        // @dev An array of holder's deposits
        Deposit[] deposits;
        DepositTimestamps[] timestamps;

        // we need to add the timestamps for the deposits
        // can we use a mapping? or just match arrays
        mapping (uint256 => timestamp?)
    }
mapping(address => User) public users;

getDeposits() returns ()

getDeposit(address _user, uint256 _depositId) returns (Deposit memory)
    return users[_user].deposits[_depositId];

getCurrentTimestamp() returns (uint256) {
    return now;
}

getRewardInfo(address _owner) returns(uint256, uint256)

unclaimedRewards(address _owner) returns(uint256)

claimedRewards()

lastClaimAt()

deposit()

withdraw()

claimRewards()

compoundRewards()

transferFees()
