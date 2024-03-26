// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GodModeToken} from "../src/GodModeToken.sol";

contract DeployToken is Script {

    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (Token) {
        vm.startBroadcast();
        Token to = new GodModeToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return to;
    }
}