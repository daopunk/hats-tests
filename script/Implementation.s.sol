// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Implementation} from "src/Implementation.sol";

// forge script script/Implementation.s.sol:ImplementationScript --rpc-url $RU --private-key $PK --broadcast --verify --etherscan-api-key $EK -vvvv

contract ImplementationScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new Implementation(
            0x37c5B029f9c3691B3d47cb024f84E5E257aEb0BB,
            0xa25256073cB38b8CAF83b208949E7f746f3BEBDc
        );
        vm.stopBroadcast();
    }
}
