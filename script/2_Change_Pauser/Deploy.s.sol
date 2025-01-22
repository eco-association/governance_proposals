pragma solidity ^0.8.0;

import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import {ChangePauser} from "src/2_Change_Pauser/ChangePauser.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    ECOx ecox = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);
    ECO eco = ECO(0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    address securityCouncil = 0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2;
    ChangePauser proposal; 

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        proposal = new ChangePauser(ecox, eco, securityCouncil);
        
        vm.stopBroadcast();
    }
}
