// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BondingCurve {
    uint256 public totalSupply;
    uint256 public constant initialPrice = 1 ether; 
    uint256 public constant slope = 0.01 ether; 
    uint256 public constant slippageTolerance = 5; // Slippage for sandwich attacks

    mapping(address => uint256) public balances;

    event TokensBought(address buyer, uint256 amount, uint256 pricePerToken);
    event TokensSold(address seller, uint256 amount, uint256 pricePerToken);

    // Function to buy tokens
    function buyTokens(uint256 numTokens, uint256 maxPricePerToken) public payable {
        require(numTokens > 0, "Must buy at least one token");
        uint256 totalPrice = calculateTotalPrice(numTokens);
        uint256 pricePerToken = totalPrice / numTokens;
        require(pricePerToken <= maxPricePerToken, "Slippage tolerance exceeded");
        
        // Slippage check
        require(msg.value >= totalPrice, "Insufficient ETH sent");
        require(((maxPricePerToken * 100) / pricePerToken) <= (100 + slippageTolerance), "Slippage tolerance exceeded");

        balances[msg.sender] += numTokens;
        totalSupply += numTokens;
        emit TokensBought(msg.sender, numTokens, pricePerToken);

        // Refund excess ETH
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }

    function sellTokens(uint256 numTokens, uint256 minPricePerToken) public {
        require(numTokens > 0 && balances[msg.sender] >= numTokens, "Invalid token amount");
        uint256 totalPrice = calculateTotalPrice(numTokens - 1) - calculateTotalPrice(numTokens - 1 - numTokens);
        uint256 pricePerToken = totalPrice / numTokens;
        require(pricePerToken >= minPricePerToken, "Slippage tolerance exceeded");

        // Slippage check
        require(((minPricePerToken * 100) / pricePerToken) >= (100 - slippageTolerance), "Slippage tolerance exceeded");

        balances[msg.sender] -= numTokens;
        totalSupply -= numTokens;
        emit TokensSold(msg.sender, numTokens, pricePerToken);
        payable(msg.sender).transfer(totalPrice);
    }

    // Function to calculate the total price for a given amount of tokens
    function calculateTotalPrice(uint256 numTokens) public view returns (uint256) {
        if (numTokens == 0) return 0;
        uint256 lastTokenPrice = initialPrice + slope * (totalSupply + numTokens - 1);
        uint256 firstTokenPrice = initialPrice + slope * totalSupply;
        return (lastTokenPrice + firstTokenPrice) / 2 * numTokens;
    }
}