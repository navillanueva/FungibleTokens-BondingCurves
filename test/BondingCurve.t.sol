// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../BondingCurve.sol"; 

contract BondingCurveTest is Test {
    BondingCurve public curve;

    function setUp() public {
        curve = new BondingCurve();
    }

    function testBuyTokens() public {
    uint256 numTokens = 10;
    uint256 maxPricePerToken = 1.05 ether; // Assuming a bit higher than initial to account for price increase
    
    // Calculate expected total price for purchasing numTokens
    uint256 expectedTotalPrice = curve.calculateTotalPrice(numTokens);

    // Expect the TokensBought event to be emitted with the correct parameters
    vm.expectEmit(true, true, true, true);

    // Buy tokens
    vm.deal(address(this), expectedTotalPrice);
    curve.buyTokens{value: expectedTotalPrice}(numTokens, maxPricePerToken);

    // Validate balances and total supply
    assertEq(curve.balances(address(this)), numTokens);
    assertEq(curve.totalSupply(), numTokens);
}

function testSellTokens() public {
    uint256 numTokensToBuy = 10;
    uint256 numTokensToSell = 5;
    uint256 minPricePerToken = 0.95 ether; // Assuming a bit lower to account for price decrease

    // Initial setup to have tokens to sell
        uint256 numTokens = 10;
        uint256 initialFunding = curve.initialPrice() + curve.slope() * numTokens;
        curve.buyTokens{value: initialFunding}(numTokens, initialFunding);

        // Expecting the TokensSold event with specific parameters
        vm.expectEmit(true, true, true, true);
        // Perform the action that should trigger the event
        curve.sellTokens(numTokensToSell, minPricePerToken);

    // Validate balances and total supply after selling
    assertEq(curve.balances(address(this)), numTokensToBuy - numTokensToSell);
    assertEq(curve.totalSupply(), numTokensToBuy - numTokensToSell);
}

}