// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GodModeToken} from "../src/GodModeToken.sol";

contract DeployGodToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (GodModeToken) {
        vm.startBroadcast();
        GodModeToken gmt = new GodModeToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return gmt;
    }
}
