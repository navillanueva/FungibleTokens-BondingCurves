// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UntrustedEscrow is ReentrancyGuard {
    address public seller;
    address public buyer;
    IERC20 public token;
    uint256 public depositAmount;
    uint256 public depositTime;
    uint256 public constant DELAY = 3 days;

    event Deposited(address indexed token, address indexed buyer, uint256 amount);
    event Withdrawn(address indexed token, address indexed seller, uint256 amount);

    constructor(address _seller, address _token) {
        seller = _seller;
        token = IERC20(_token);
    }

    // Allows the buyer to deposit tokens into the escrow
    function deposit(uint256 amount) external nonReentrant {
        require(depositAmount == 0, "Deposit already made");

        // Transfer tokens from the buyer to this contract
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        buyer = msg.sender;
        depositAmount = amount;
        depositTime = block.timestamp;

        emit Deposited(address(token), buyer, amount);
    }

    // Allows the seller to withdraw the tokens after the delay
    function withdraw() external nonReentrant {
        require(msg.sender == seller, "Only seller can withdraw");
        require(block.timestamp >= depositTime + DELAY, "Delay not yet passed");
        require(depositAmount > 0, "No deposit to withdraw");

        uint256 amount = depositAmount;
        depositAmount = 0; // Prevent reentrancy

        require(token.transfer(seller, amount), "Transfer failed");

        emit Withdrawn(address(token), seller, amount);
    }
}
