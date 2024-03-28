// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {BondingCurve} from "../src/BondingCurve.sol";

contract DeployBondingCurve is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (BondingCurve) {
        vm.startBroadcast();
        BondingCurve bc = new BondingCurve();
        vm.stopBroadcast();
        return bc;
    }
}
