// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/StakeToken.sol";

contract StakeTokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        YesToken yesToken = new YesToken(10000);
        vm.stopBroadcast();
    }
}
