// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BondingCurve {
    uint256 public totalSupply;
    uint256 public constant initialPrice = 1 ether;
    uint256 public constant slope = 0.01 ether;
    uint256 public constant slippageTolerance = 5; // Percent slippage tolerance to prevent sandwich attacks

    mapping(address => uint256) public balances;

    event TokensBought(address indexed buyer, uint256 amount, uint256 pricePerToken);
    event TokensSold(address indexed seller, uint256 amount, uint256 pricePerToken);

    error InsufficientETHSent();
    error InvalidTokenAmount();
    error PriceOutOfRange();

    function buyTokens(uint256 numTokens) external payable {
        if (numTokens == 0) revert InvalidTokenAmount();
        uint256 totalPrice = _calculateTotalPrice(numTokens);
        uint256 pricePerToken = totalPrice / numTokens;
        uint256 maxPricePerToken = pricePerToken * (100 + slippageTolerance) / 100;

        // round up
        if (msg.value < totalPrice) revert InsufficientETHSent();
        if (msg.value > maxPricePerToken * numTokens) revert PriceOutOfRange();

        balances[msg.sender] += numTokens;
        totalSupply += numTokens;
        emit TokensBought(msg.sender, numTokens, pricePerToken);

        // Refund excess ETH
        // protocols usually keep the excess eth
        // there could possibly be reentrancy in this call function
        // safest is to not do this
        if (msg.value > totalPrice) {
            (bool success,) = msg.sender.call{value: msg.value - totalPrice}("");
            require(success, "ETH refund failed");
        }
    }

    function sellTokens(uint256 numTokens) external {
        if (numTokens == 0 || balances[msg.sender] < numTokens) revert InvalidTokenAmount();
        uint256 totalPriceBefore = _calculateTotalPrice(numTokens);
        totalSupply -= numTokens;
        uint256 totalPriceAfter = _calculateTotalPrice(numTokens);
        uint256 totalPrice = totalPriceBefore - totalPriceAfter;
        uint256 pricePerToken = totalPrice / numTokens;
        uint256 minPricePerToken = pricePerToken * (100 - slippageTolerance) / 100;

        if (minPricePerToken * numTokens > totalPrice) revert PriceOutOfRange();

        balances[msg.sender] -= numTokens;
        emit TokensSold(msg.sender, numTokens, pricePerToken);
        (bool success,) = msg.sender.call{value: totalPrice}("");
        require(success, "ETH transfer failed");
    }

    function _calculateTotalPrice(uint256 numTokens) internal view returns (uint256) {
        if (numTokens == 0) return 0;
        uint256 lastTokenPrice = initialPrice + slope * (totalSupply + numTokens - 1);
        uint256 firstTokenPrice = initialPrice + slope * totalSupply;
        return ((lastTokenPrice + firstTokenPrice) * numTokens) / 2;
    }
}
