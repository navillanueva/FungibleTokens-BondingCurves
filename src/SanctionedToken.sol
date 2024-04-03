// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error AddressAlreadyBanned(address _address);
error AddressNotBanned(address _address);
error TransferToBannedAddress(address sender, address recipient);
error TransferFromBannedAddress(address sender, address recipient, address operator);

contract SanctionedToken is ERC20, Ownable {
    mapping(address => bool) public banned;

    // question: should these go here or between the imports and the contract
    // question: what is the difference between errors and events declared oustide of the contract and those declared inside of the contract

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC20(name, symbol)
        Ownable(initialOwner)
    {
        _mint(msg.sender, 1000000e18);
    }

    function banAddress(address _address) external onlyOwner {
        if (banned[_address]) revert AddressAlreadyBanned(_address);
        banned[_address] = true;
    }

    function unbanAddress(address _address) external onlyOwner {
        if (!banned[_address]) revert AddressNotBanned(_address);
        banned[_address] = false;
    }

    // Override transfer function
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (banned[msg.sender] || banned[recipient]) {
            revert TransferToBannedAddress(msg.sender, recipient);
        }
        return super.transfer(recipient, amount);
    }

    // Override transferFrom function
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        if (banned[sender] || banned[recipient] || banned[msg.sender]) {
            revert TransferFromBannedAddress(sender, recipient, msg.sender);
        }
        return super.transferFrom(sender, recipient, amount);
    }
}
