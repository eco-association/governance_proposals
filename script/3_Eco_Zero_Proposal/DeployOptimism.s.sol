pragma solidity ^0.8.0;

import {EcoZeroL2} from "../../src/3_Eco_Zero_Proposal/EcoZeroL2.sol";
import "forge-std/Script.sol";

contract DeployOptimism is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        EcoZeroL2 ecoZeroL2 = new EcoZeroL2();

        vm.stopBroadcast();
    }
}