import {Test} from "forge-std/Test.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import "./../src/3_Eco_Zero_Proposal/ECOZero.sol";
import "./../src/3_Eco_Zero_Proposal/EcoZeroProposal.sol";
import "forge-std/console.sol";
import "./utils/UniswapV2Pair.sol";

contract ForkTest is Test {
 
    uint256 mainnetFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // protocol addresses
    address constant securityCouncil = 0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2; 
    address constant previousMultisig = 0x99f98ea4A883DB4692Fa317070F4ad2dC94b05CE;
    IUniswapV2Pair ecoPair = IUniswapV2Pair(0x09bC52B9EB7387ede639Fc10Ce5Fa01CBCBf2b17);
    address constant ecoPairLP = 0x26bF0495fE1c40256fE9F72278724fac538B9828;

    ECO  eco  = ECO (0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    
    // proposal address
    EcoZeroProposal proposal; 
    ECOZero ecoZero;

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL, 21634901);
        ecoZero = new ECOZero(policy, securityCouncil);
        proposal = new EcoZeroProposal(address(ecoZero), eco);
    }

    function testCurrencyGovernanceCanPass() public {
        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // check the balance of the previous multisig
        assertEq(eco.balanceOf(previousMultisig), 2282391506509296369997455688);

        // check the voting power of the previous multisig
        assertEq(eco.voteBalanceOf(previousMultisig), 2282391506509296369997455688);

        // check the vote balance snapshot of the previous multisig
        assertEq(eco.voteBalanceSnapshot(previousMultisig), 2282391506509296369997455688);

        // check the total supply
        assertEq(eco.totalSupply(), 9186775387079571651579250584);

        // check the total supply snapshot
        assertEq(eco.totalSupplySnapshot(), 9186775387079571651579250584);

        // check the balance of the eco pair
        assertEq(eco.balanceOf(address(ecoPair)), 61471865558087391490616650);

        // enact the proposal
        vm.prank(securityCouncil);
        policy.enact(address(proposal));

        // check the balance of the previous multisig
        assertEq(eco.balanceOf(previousMultisig), 0);

        // check the voting power of the previous multisig
        assertEq(eco.voteBalanceOf(previousMultisig), 0);

        // check the vote balance snapshot of the previous multisig
        assertEq(eco.voteBalanceSnapshot(previousMultisig), 0);

        // check the total supply
        assertEq(eco.totalSupply(), 0);

        // check the total supply snapshot
        assertEq(eco.totalSupplySnapshot(), 0);

        // check the balance of the eco pair
        assertEq(eco.balanceOf(address(ecoPair)), 0);

        //sync the pair 
        ecoPair.sync();

        // check the balance of the eco pair
        assertEq(eco.balanceOf(address(ecoPair)), 0);

        // check that swapping from eco token to the pair is not possible
        //TODO: implement this

        // check if you can burn lp tokens to get back eco and usdc
        assertEq(ecoPair.balanceOf(address(ecoPairLP)), 5247691049867031287); // 
        vm.prank(address(ecoPair));
        ecoPair.burn(address(ecoPairLP));
        assertEq(eco.balanceOf(address(ecoPairLP)), 0);
    }
}