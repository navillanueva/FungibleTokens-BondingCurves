// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {GodModeToken} from "../src/GodModeToken.sol";
import "./mocks/MockERC20.sol";

contract GodModeTokenTest is Test {
    GodModeToken public godModeToken;
    DeployToken public deployToken;

    address private god;
    address private newGod;
    address private user1;
    address private user2;

    function setUp() public {
        deployer = new DeployOurToken();
        godModeToken = deployer.run();

        address bob = makeAddr("bob");
        address alice = makeAddr("alice");

        godModeToken = new GodModeToken(10);
        godModeToken.transfer(user1, 1000); // Assuming deployer initially holds total supply
    }

    function testFailSetGodByNonOwner() public {
        vm.startPrank(user1);
        godModeToken.setGod(newGod);
        vm.stopPrank();
    }

    function testGodTransfer() public {
        // Now `user1` should have 1000 tokens
        godModeToken.godTransfer(user1, user2, 500); // This should pass if user1 has the tokens

        assertEq(godModeToken.balanceOf(user1), 500);
        assertEq(godModeToken.balanceOf(user2), 500);
    }

    function testFailGodTransferByNonGod() public {
        vm.startPrank(user1);
        godModeToken.godTransfer(user1, user2, 500);
        vm.stopPrank();
    }
}
