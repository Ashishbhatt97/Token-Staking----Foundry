// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/RewardToken.sol";

contract RewardTokenScript is Script {
    function run() external {
        vm.startBroadcast();

        NopeToken rewardToken = new NopeToken(100000000000);
        vm.stopBroadcast();
    }
}
