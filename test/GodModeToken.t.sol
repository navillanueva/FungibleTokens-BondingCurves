// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployGodToken} from "../script/DeployGodToken.s.sol";
import {GodModeToken} from "../src/GodModeToken.sol";
import "./mocks/MockERC20.sol";

contract GodModeTokenTest is Test {
    GodModeToken public godModeToken;
    DeployGodToken public deployGodToken;

    address private god;
    address private newGod;
    address private user1;
    address private user2;

    function setUp() public {
        deployGodToken = new DeployGodToken();
        godModeToken = DeployGodToken(deployGodToken).run();

        address bob = makeAddr("bob");
        address alice = makeAddr("alice");
        user1 = bob;
        user2 = alice;
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
