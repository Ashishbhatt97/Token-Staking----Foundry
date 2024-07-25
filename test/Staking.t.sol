// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Staking.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract StakingTest is Test {
    Staking public stakingInstance;
    Token public stakingToken;
    Token public rewardToken;

    address public user = address(0x123);
    uint256 public initialSupply = 1000000 ether;

    function setUp() public {
        stakingToken = new Token("YesToken", "YTK");
        rewardToken = new Token("NopeToken", "NTK");
        stakingInstance = new Staking(
            address(stakingToken),
            address(rewardToken)
        );

        stakingToken.mint(user, initialSupply);
        rewardToken.mint(address(stakingInstance), initialSupply);

        vm.startPrank(user);

        stakingToken.approve(address(stakingInstance), initialSupply);
        vm.stopPrank();
    }

    function testStakeToken() public {
        vm.startPrank(user);
        stakingInstance.stake(10 ether);

        vm.stopPrank();

        assertEq(stakingInstance.stakedBalance(user), 10 ether);
        assertEq(stakingToken.balanceOf(user), 1000000 ether - 10 ether);
    }

    function testWithdrawToken() public {
        vm.startPrank(user);

        stakingInstance.stake(10 ether);
        vm.warp(block.timestamp + 1 days);
        stakingInstance.claimReward();
        vm.stopPrank();

        uint256 expectedRewardTokens = 1 days * stakingInstance.Reward_Rate();
        assertEq(rewardToken.balanceOf(user), expectedRewardTokens);
    }

    function testStakeAndWithdrawToken() public {
        vm.startPrank(user);
        stakingInstance.stake(10 ether);
        vm.warp(block.timestamp + 1 days);
        stakingInstance.claimReward();
        stakingInstance.withdrawnToken(10 ether);
        vm.stopPrank();

        uint256 expectedRewardTokens = 1 days * stakingInstance.Reward_Rate();
        assertEq(rewardToken.balanceOf(user), expectedRewardTokens);
        assertEq(stakingInstance.stakedBalance(user), 0);
        assertEq(stakingToken.balanceOf(user), initialSupply);
    }
}
