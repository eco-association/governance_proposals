import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";
import {L2ECO} from "op-eco/token/L2ECO.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import {L1ECOBridge} from "op-eco/bridge/L1ECOBridge.sol";
import {L2ECOBridge} from "op-eco/bridge/L2ECOBridge.sol";
import {IL1CrossDomainMessenger} from "@eth-optimism/contracts/L1/messaging/IL1CrossDomainMessenger.sol";
import {IL2CrossDomainMessenger} from "@eth-optimism/contracts/L2/messaging/IL2CrossDomainMessenger.sol";
import {L2ECO} from "op-eco/token/L2ECO.sol";
import "./../src/3_Eco_Zero_Proposal/EcoZero.sol";
import "./../src/3_Eco_Zero_Proposal/EcoZeroL2.sol";
import "./../src/3_Eco_Zero_Proposal/EcoZeroProposal.sol";
import "./utils/UniswapV2Pair.sol";

contract ForkTest is Test {
    uint256 mainnetFork;
    uint256 optimismFork;
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    // L1 protocol addresses
    address constant securityCouncil =
        0xCF2A6B4bc14A1FEf0862c9583b61B1beeDE980C2;
    address constant previousMultisig =
        0x99f98ea4A883DB4692Fa317070F4ad2dC94b05CE;
    ECO eco = ECO(0x8dBF9A4c99580fC7Fd4024ee08f3994420035727);
    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    L1ECOBridge l1ECOBridge =
        L1ECOBridge(0xAa029BbdC947F5205fBa0F3C11b592420B58f824);
    IL1CrossDomainMessenger l1Messenger =
        IL1CrossDomainMessenger(0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1);
    EcoZeroProposal proposal;
    ECOZero ecoZero;

    //L1 other addresses
    IUniswapV2Pair ecoPair =
        IUniswapV2Pair(0x09bC52B9EB7387ede639Fc10Ce5Fa01CBCBf2b17);
    address constant ecoPairLP = 0x26bF0495fE1c40256fE9F72278724fac538B9828;

    //L2 contracts
    IL2CrossDomainMessenger l2Messenger =
        IL2CrossDomainMessenger(0x4200000000000000000000000000000000000007);
    L2ECOBridge l2ECOBridge =
        L2ECOBridge(0xAa029BbdC947F5205fBa0F3C11b592420B58f824);
    L2ECO l2ECO = L2ECO(0xe7BC9b3A936F122f08AAC3b1fac3C3eC29A78874);
    EcoZeroL2 ecoZeroL2;

    //events
    event UpgradeL2ECO(address proposal);
    event SentMessage(address indexed target, address sender, bytes message, uint256 messageNonce, uint256 gasLimit);
    event SentMessageExtension1(address indexed sender, uint256 value);


    function setUp() public {
        optimismFork = vm.createSelectFork(OPTIMISM_RPC_URL, 131023758);
        ecoZeroL2 = new EcoZeroL2();
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL, 21634901);
        ecoZero = new ECOZero(policy, securityCouncil);
        proposal = new EcoZeroProposal(
            address(ecoZero),
            address(ecoZeroL2),
            l1ECOBridge,
            eco,
            10000
        );
    }

    function testEcoReplacementL1Pass() public {
        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // check the Eco token name and symbol
        assertEq(eco.name(), "ECO");
        assertEq(eco.symbol(), "ECO");

        // check the balance of the previous multisig
        assertEq(eco.balanceOf(previousMultisig), 2282391506509296369997455688);

        // check the voting power of the previous multisig
        assertEq(
            eco.voteBalanceOf(previousMultisig),
            2282391506509296369997455688
        );

        // check the vote balance snapshot of the previous multisig
        assertEq(
            eco.voteBalanceSnapshot(previousMultisig),
            2282391506509296369997455688
        );

        // check the total supply
        assertEq(eco.totalSupply(), 9186775387079571651579250584);

        // check the total supply snapshot
        assertEq(eco.totalSupplySnapshot(), 9186775387079571651579250584);

        // check the balance of the eco pair
        assertEq(eco.balanceOf(address(ecoPair)), 61471865558087391490616650);

        // enact the proposal
        vm.prank(securityCouncil);
        policy.enact(address(proposal));

        // check the name and symbol of the Eco token
        assertEq(eco.name(), "0xdead");
        assertEq(eco.symbol(), "0xdead");

        console.log("new eco name and symbol", eco.name(), eco.symbol());

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

        // this should revert with "UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED"
        vm.expectRevert("UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED");
        ecoPair.burn(address(ecoPairLP));

        assertEq(eco.balanceOf(address(ecoPairLP)), 0);
    }

    function testEcoReplacementL1Message() public {
        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // should emit SentMessage(address indexed target, address sender, bytes message, uint256 messageNonce, uint256 gasLimit);
        bytes memory message = abi.encodeWithSelector(
            L2ECOBridge.upgradeECO.selector,
            address(ecoZeroL2),
            block.number
        );
        console.logBytes(message);
        (bool success, bytes memory returnData) = address(l1Messenger).call(abi.encodeWithSignature("messageNonce()"));
        require(success, "call to messageNonce() failed");
        uint256 currentNonce = abi.decode(returnData, (uint256));

        vm.expectEmit(true, false, false, true, address(l1Messenger));
        emit SentMessage(address(l2ECOBridge), address(l1ECOBridge), message, currentNonce, 10000);

        // should emit SentMessageExtension1(msg.sender, msg.value);
        vm.expectEmit(true, false, false, true, address(l1Messenger));
        emit SentMessageExtension1(address(l1ECOBridge), 0);
        
        // should emit UpgradeL2ECO(_impl);
        vm.expectEmit(address(l1ECOBridge));
        emit UpgradeL2ECO(address(ecoZeroL2));

        // should call CrossDomainMessenger.sendMessage 
        bytes memory data = abi.encodeWithSelector(
            l1Messenger.sendMessage.selector,
            address(l2ECOBridge),
            message,
            10000
        );
        vm.expectCall(address(l1Messenger), data);


        //enact the proposal
        vm.prank(securityCouncil);
        policy.enact(address(proposal));
    }
}
