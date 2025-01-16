// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import {TrustedNodes} from "currency-1.5/governance/monetary/TrustedNodes.sol";
import "./../../src/1_Trustee_Payout/TrusteePayout.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    ECOx ecox = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    address constant currencyGovernance = 0x039F39846C6F9911993809C7488eF4502208cE4B; 
    address constant trustedNodes = 0x9fA130E9d1dA166164381F6d1de8660da0afc1f1;
    TrusteePayout proposal; 

    function run() public {
            // read and decode the JSON file for addresses
    string memory json_addresses = vm.readFile("script/addresses.json");
    string memory json_rec = vm.readFile("script/payouts.json");

    address[] memory recipients = abi.decode(vm.parseJson(json_addresses, ".addresses"), (address[]));
    uint256[] memory payouts = abi.decode(vm.parseJson(json_rec, ".payouts"), (uint256[]));

    // logging the recipients and payouts for verification
    for (uint i = 0; i < recipients.length; i++) {
        console.log("Recipient:", recipients[i]);
    }
    for (uint i = 0; i < payouts.length; i++) {
        console.log("Payout:", payouts[i]);
    }

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        proposal = new TrusteePayout(recipients, payouts, ecox, trustedNodes);

        vm.stopBroadcast();
    }
}