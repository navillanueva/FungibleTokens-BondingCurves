// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {SanctionedToken} from "../src/SanctionedToken.sol";

// numbering the scripts could be benefcial

contract DeploySanctionedToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (SanctionedToken) {
        vm.startBroadcast();
        SanctionedToken st = new SanctionedToken("SanctionedToken", "SNT", address(this));
        vm.stopBroadcast();
        return st;
    }
}
