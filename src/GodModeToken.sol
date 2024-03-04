// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// lose reentrancy guard
contract GodModeToken is ERC20, ReentrancyGuard, Ownable {
    address private god;

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC20(name, symbol)
        ReentrancyGuard()
        Ownable(initialOwner)
    {
        god = msg.sender;
        _mint(msg.sender, 1000000e18);
    }

    // Set a new controller
    // issue event
    function setGod(address _newGod) external onlyOwner {
        god = _newGod;
    }

    // Controller transfers tokens from one address to another
    // not sure if this overrides the regulat transFrom function
    // no need to be non reentrant
    // custom errror
    // should have an event
    function godTransfer(address from, address to, uint256 amount) external nonReentrant {
        require(msg.sender == god, "Only the god can perform this action.");
        require(from != address(0) && to != address(0), "Invalid address."); // double check this require because it might already be inside the openzeppelin contract and other logix
        _transfer(from, to, amount);
    }
}
