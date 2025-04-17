pragma solidity ^0.8.0;

import {ECO} from "currency-1.5/currency/ECO.sol";
import {EcoZeroProposal} from "../../src/3_Eco_Zero_Proposal/EcoZeroProposal.sol";
import {ECOZero} from "../../src/3_Eco_Zero_Proposal/EcoZero.sol";
import {L1ECOBridge} from "op-eco/bridge/L1ECOBridge.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";

import "forge-std/Script.sol";

contract DeployMainnet is Script {
    // proposal, policy and council
    address securityCouncil = 0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2;
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    EcoZeroProposal proposal; 

    // proposal constructor
    ECOZero ecoZero;
    address ecoZeroL2; 
    L1ECOBridge l1ECOBridge = L1ECOBridge(0xAa029BbdC947F5205fBa0F3C11b592420B58f824);
    ECO eco = ECO(0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    uint32 l2gas = 400000;

    function run(address _ecoZeroL2) public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        ecoZeroL2 = _ecoZeroL2;
        vm.startBroadcast(deployerPrivateKey);
        ecoZero = new ECOZero(policy, securityCouncil);
        EcoZeroProposal ecoZeroProposal = new EcoZeroProposal(
            address(ecoZero),
            ecoZeroL2,
            l1ECOBridge,
            eco,
            l2gas
        );
        vm.stopBroadcast();

    }
}