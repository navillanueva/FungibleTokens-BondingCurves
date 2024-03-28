// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GodModeToken is ERC20, Ownable {
    address private god;

    event GodSet(address god);
    event GodTransfer(address indexed from, address indexed to, uint256 amount);

    error NotGod(address caller);
    error InvalidAddress();

    constructor(uint256 initialSupply) ERC20("GodToken", "GOD") Ownable(msg.sender) {
        god = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    function setGod(address _newGod) external onlyOwner {
        god = _newGod;
        emit GodSet(_newGod);
    }

    function godTransfer(address from, address to, uint256 amount) external {
        if (msg.sender != god) revert NotGod(msg.sender);
        _transfer(from, to, amount);
        emit GodTransfer(from, to, amount);
    }
}
