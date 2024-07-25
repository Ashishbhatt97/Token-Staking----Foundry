// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/StakeToken.sol";

contract StakeTokenTest is Test {
    YesToken public stakeToken;

    function setUp() public {
        stakeToken = new YesToken(1000);
    }

    function initialSupplyTest() public view {
        assertEq(stakeToken.totalSupply(), 1000 * 10 ** 18);
        assertEq(stakeToken.balanceOf(address(this)), 1000 * 10 ** 18);
    }

    function transferTokenTest() public {
        address receiver = address(0x123);
        stakeToken.transfer(receiver, 200 * 10 ** 18);
        assertEq(stakeToken.balanceOf(receiver), 200 * 10 ** 18);
        assertEq(stakeToken.balanceOf(address(this)), 800 * 10 ** 18);
    }
}
