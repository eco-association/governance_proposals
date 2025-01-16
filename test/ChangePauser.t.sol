import {Test} from "forge-std/Test.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import "./../src/2_Change_Pauser/ChangePauser.sol";
import "forge-std/console.sol";

contract ForkTest is Test {
 
    uint256 mainnetFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // Security Council multisig
    address constant previousMultisig = 0x99f98ea4A883DB4692Fa317070F4ad2dC94b05CE;
    address constant securityCouncil = 0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2; 

    // protocol contract
    ECOx ecox = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);
    ECO  eco  = ECO (0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    
    // proposal address
    ChangePauser proposal; 

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL, 21634901);
    }

    function testCurrencyGovernanceCanPass() public {

        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // check that the previous multisig is the pauser
        assertEq(ecox.pauser(), previousMultisig);
        assertEq(eco.pauser(), previousMultisig);

        // check that the new pauser is not a pauser yet
        assertFalse(ecox.pauser() == securityCouncil);
        assertFalse(eco.pauser() == securityCouncil);

        // deploy the proposal
        proposal = new ChangePauser(ecox, eco, securityCouncil);

        // enact the proposal
        vm.prank(securityCouncil);
        policy.enact(address(proposal));

        // check that the new pauser is the security council
        assertEq(ecox.pauser(), securityCouncil);
        assertEq(eco.pauser(), securityCouncil);

        // check that the previous multisig is no longer a pauser
        assertFalse(ecox.pauser() == previousMultisig);
        assertFalse(eco.pauser() == previousMultisig);
    }
}