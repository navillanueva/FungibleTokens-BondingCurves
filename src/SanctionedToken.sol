// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SanctionedToken is ERC20, Ownable {
    mapping(address => bool) public banned;

    constructor(string memory name, string memory symbol, address initialOwner) ERC20(name, symbol) Ownable(initialOwner) {
    // Contract body

    }

    // Admin can ban an address
    function banAddress(address _address) external onlyOwner {
        require(!banned[_address], "Address is already banned");
        banned[_address] = true;
    }

    // Admin can unban an address
    function unbanAddress(address _address) external onlyOwner {
        require(banned [_address], "Address is not banned");
        banned[_address] = false;
    }

    // Override transfer function
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!banned[msg.sender] && !banned[recipient], "Sender or recipient is banned");
        return super.transfer(recipient, amount);
    }

    // Override transferFrom function
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(
            !banned[sender] && !banned[recipient] && !banned[msg.sender], "Sender, recipient, or operator is banned"
        );
        return super.transferFrom(sender, recipient, amount);
    }
}
