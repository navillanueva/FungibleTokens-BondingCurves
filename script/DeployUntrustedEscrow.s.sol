// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {UntrustedEscrow} from "../src/UntrustedEscrow.sol";

contract DeployUntrustedEscrow is Script {

    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (UntrustedEscrow) {
        vm.startBroadcast();
        UntrustedEscrow ue = new UntrustedEscrow();
        vm.stopBroadcast();
        return ue;
    }
}