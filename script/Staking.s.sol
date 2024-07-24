// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/Staking.sol";

contract StakingScript is Script {
    Staking public stakeInstance;

    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        stakeInstance = new Staking(vm.addr(0x1), vm.addr(0x33));
        vm.stopBroadcast();
    }
}
