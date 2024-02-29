// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GodModeToken is ERC20, ReentrancyGuard, Ownable {
    address private controller;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
    {
        controller = msg.sender; // Initialize the controller as the deployer
    }

    // Set a new controller
    function setController(address _newController) external onlyOwner {
        controller = _newController;
    }

    // Controller transfers tokens from one address to another
    function controllerTransfer(address from, address to, uint256 amount) external nonReentrant {
        require(msg.sender == controller, "Only the controller can perform this action.");
        require(from != address(0) && to != address(0), "Invalid address.");
        _transfer(from, to, amount);
    }
}
