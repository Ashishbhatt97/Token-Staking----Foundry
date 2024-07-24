// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YesToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("YesToken", "YTK") {
        _mint(msg.sender, initialSupply * 10 ** 18);
    }
}
