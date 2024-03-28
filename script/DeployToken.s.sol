// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GodModeToken} from "../src/GodModeToken.sol";
import {SanctionedToken} from "../src/SanctionedToken.sol";
import {UntrustedEscrow} from "../src/UntrustedEscrow.sol";
import {BondingCurve} from "../src/BondingCurve.sol";

contract DeployToken is Script {

    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function runGod() external returns (GodModeToken) {
        vm.startBroadcast();
        GodModeToken gmt = new GodModeToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return gmt;
    }

    function runSanction() external returns (SanctionedToken){
        vm.startBroadcast();
        SanctionedToken st = new SanctionedToken("SanctionedToken", "SNT", address(this));
        vm.stopBroadcast();
        return st;
    }

    function runEscrow(address seller, address token) external returns (UntrustedEscrow){
        vm.startBroadcast();
        UntrustedEscrow ue = new UntrustedEscrow(address(this), address(this));
        vm.stopBroadcast();
        return ue;
    }

    function runBondingCurve() external returns (BondingCurve){
        vm.startBroadcast();
        BondingCurve bc = new BondingCurve();
        vm.stopBroadcast();
        return bc;
    }
}