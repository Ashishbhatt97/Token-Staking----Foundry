// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";

contract NopeTokenTest is Test {
    NopeToken public rewardToken;

    function setUp() public {
        rewardToken = new NopeToken(100000);
    }

    function testInitialSupply() public view {
        assertEq(rewardToken.totalSupply(), 100000 * 10 ** 18);
        assertEq(rewardToken.balanceOf(address(this)), 100000 * 10 ** 18);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        rewardToken.transfer(recipient, 1000 * 10 ** 18);
        assertEq(rewardToken.balanceOf(recipient), 1000 * 10 ** 18);
        assertEq(rewardToken.balanceOf(address(this)), 99000 * 10 ** 18);
    }
}
