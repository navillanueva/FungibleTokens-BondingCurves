// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeploySanctionedToken} from "../script/DeploySanctionedToken.s.sol";
import {SanctionedToken} from "../src/SanctionedToken.sol";

contract SanctionedTokenTest is Test {
    SanctionedToken public sanctionedToken;
    DeploySanctionedToken public deploySanctionedToken;

    address private owner;
    address private user1;
    address private user2;

    function setUp() public {
        deploySanctionedToken = new DeploySanctionedToken();
        sanctionedToken = DeploySanctionedToken(deploySanctionedToken).run();

        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        sanctionedToken = new SanctionedToken("SanctionedToken", "SNT", owner);
    }

    // function testInitialOwner() public {
    //     assertEq(token.owner(), owner);
    // }

    // function testBanAndUnbanAddress() public {
    //     assertFalse(token.banned(user1));

    //     // Ban user1
    //     token.banAddress(user1);
    //     assertTrue(token.banned(user1));

    //     // Unban user1
    //     token.unbanAddress(user1);
    //     assertFalse(token.banned(user1));
    // }

    // function testTransferFromWithBannedAddress() public {
    //     // Transfer tokens to user1 for testing; ensure this contract has tokens to transfer
    //     token.transfer(user1, 1000e18);
    //     // Impersonate user1 to approve this contract to spend tokens on their behalf
    //     vm.prank(user1);
    //     token.approve(address(this), 1000e18);

    //     // Ban one of the addresses involved in the transfer
    //     token.banAddress(user1);

    //     // Expect the transfer from user1 to user2 to revert due to the ban
    //     vm.expectRevert(bytes("Sender, recipient, or operator is banned"));
    //     token.transferFrom(user1, user2, 100e18);
    // }
}
