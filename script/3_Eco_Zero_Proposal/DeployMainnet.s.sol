pragma solidity ^0.8.0;

import {ECO} from "currency-1.5/currency/ECO.sol";
import {EcoZeroProposal} from "src/3_Eco_Zero_Proposal/EcoZeroProposal.sol";
import {EcoZeroL2} from "src/3_Eco_Zero_Proposal/EcoZeroL2.sol";
import "forge-std/Script.sol";

contract DeployMainnet is Script {
    ECO eco = ECO(0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    address securityCouncil = 0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2;
    EcoZeroProposal proposal; 
    EcoZeroL2 ecoZeroL2;

            address _newECOImpl,
        address _newL2ECOImpl,
        L1ECOBridge _l1ECOBridge,
        ECO _eco,
        uint32 _l2gas

    function run() public override {
        ECO eco = new ECO();
        EcoZeroProposal ecoZeroProposal = new EcoZeroProposal(eco);
        EcoZeroL2 ecoZeroL2 = new EcoZeroL2(ecoZeroProposal);
    }
}