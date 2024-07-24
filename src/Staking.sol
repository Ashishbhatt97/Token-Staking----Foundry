// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Staking is ReentrancyGuard {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public constant Reward_Rate = 1e18;
    uint256 private totalStakedTokens;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdatedTime;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public userRewardPerTokenPaid;

    event Staked(address indexed user, uint256 indexed amount);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardsClaimed(address indexed user, uint256 indexed amount);

    modifier updateRewardToken(address _account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdatedTime = block.timestamp;
        rewards[_account] = tokenEarned(_account);
        userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        _;
    }

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalStakedTokens == 0) {
            return rewardPerTokenStored;
        }

        uint256 totaltime = block.timestamp - lastUpdatedTime;
        uint256 totalRewards = Reward_Rate * totaltime;

        return rewardPerTokenStored + totalRewards / totalStakedTokens;
    }

    function tokenEarned(address _account) public view returns (uint256) {
        return
            (stakedBalance[_account]) *
            (rewardPerToken() - userRewardPerTokenPaid[_account]);
    }

    function stake(
        uint256 amount
    ) external nonReentrant updateRewardToken(msg.sender) {
        require(amount > 0, "Amount must be greater than 0");
        totalStakedTokens += amount;
        stakedBalance[msg.sender] += amount;

        emit Staked(msg.sender, amount);
        bool success = stakingToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Transfer failed");
    }

    function withdrawnToken(
        uint256 amount
    ) external nonReentrant updateRewardToken(msg.sender) {
        require(amount > 0, "Amount must be greater than 0");
        totalStakedTokens -= amount;
        stakedBalance[msg.sender] -= amount;
        emit Withdrawn(msg.sender, amount);

        bool success = stakingToken.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }

    function claimReward() external nonReentrant updateRewardToken(msg.sender) {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        emit RewardsClaimed(msg.sender, reward);

        bool success = rewardToken.transfer(msg.sender, reward);
        require(success, "Transfer failed");
    }
}
