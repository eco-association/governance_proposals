import {Test} from "forge-std/Test.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import {TrustedNodes} from "currency-1.5/governance/monetary/TrustedNodes.sol";
import "./../src/1_Trustee_Payout/TrusteePayout.sol";
import "forge-std/console.sol";

contract ForkTest is Test {
 
    uint256 mainnetFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address constant currencyGovernance = 0x039F39846C6F9911993809C7488eF4502208cE4B; 

    address constant trustedNodes = 0x9fA130E9d1dA166164381F6d1de8660da0afc1f1;

    ECOx ecox = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);

    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);
    
    TrusteePayout proposal; 

    address[] public recipients;

    uint256[] public payouts;

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL, 21021900);

        // Trustees
        recipients= [
            address(0x4Facb0b7E7094865644a5Ef342725E4B29e89507), 
            address(0x50AAfE7e967961BdB5c0EfB9B18e94A8079Dd4D0), 
            address(0xAa7dBAd572C6657033a80916482d0651d27f1587), 
            address(0x4d5755EFfc4879CAa66d01d5085cfaaEd569897f), 
            address(0x2E85d4023E54c7E8c54706faccFeA8617eaaC81b), 
            address(0x9B0D64027c38532d7842773a2Bf9aeBc6d070855), 
            address(0x6F4018069323487D2638641f2A09fbCb867D19dB), 
            address(0x560D8ce16d4CA732FdD2811f19De73f7f37eBA56), 
            address(0xC741F882643db525F6bb5eDea3AAAdd80f987F2A), 
            address(0xA836E2593650d13c57045d614eCd3270F30e8d38), 
            address(0xCd078226faBfbC91e28474c4FE1d290E955b370f), 
            address(0x0f4259f494f224b2eb499d6291aa846ab592e336), 
            address(0x41Fa896616a2Bf60a0bB9391De4bb0b7eA122b07), 
            address(0x5dD5d553DBE6e0a132eC30d040E8bDc3c2bB55d4), 
            address(0x51C25c30717A2cf080C2754307Ca5ebf1A9a4644), 
            address(0x9c8760B9255D8f20f729F8c27EC2C4D7b2FdC024), 
            address(0xeCe5E82Ed8F37094A6D46b007a4Ada80ae74d006), 
            address(0x12c3B447BAC4EBF031ED0B67b84bAd7f783813F9), 
            address(0x7fCD15dF454B3ae8646e654CA2fB763C782d39D3), 
            address(0xcb7b385BB8932a33aeE979d9247F0d647021027C), 
            address(0x2C5fA9B3E3fD6ab32589B5A0Ee08C0a166dC53e6), 
            address(0xf4D3E8F6B9874FACe34AD8b49E1932A27C92A8F4)];
            
        // Payouts
        payouts = [
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
            1,
            2
        ];

    }

    function testCurrencyGovernanceCanPass() public {
        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // check that policy is not minter or burner
        assertFalse(ecox.minters(address(policy)));
        assertFalse(ecox.burners(address(policy)));

        // get balance of ECOx in TrustedNodes contract
        uint256 balanceTrustedNodes = ecox.balanceOf(trustedNodes);

        // get the balance of the Policy contract
        uint256 balancePolicy = ecox.balanceOf(address(policy));

        // get the balance of each recipient pre-proposal
        uint256[] memory balancesTrustees = new uint256[](recipients.length);
        for (uint256 i = 0; i < recipients.length; i++) {
            balancesTrustees[i] = ecox.balanceOf(recipients[i]);
        }

        // create the proposal
        proposal = new TrusteePayout(
            recipients,
            payouts,
            ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a),
            0x9fA130E9d1dA166164381F6d1de8660da0afc1f1
        );

        // enact the proposal
        vm.prank(currencyGovernance);
        policy.enact(address(proposal));
    
        // check that policy is now a minter and burner
        assertTrue(ecox.minters(address(policy)));
        assertTrue(ecox.burners(address(policy)));

        // check that the balance of the TrustedNodes contract is now 0
        assertEq(ecox.balanceOf(trustedNodes), 0);
        uint256 proposalVoteReward = 9615000000000000000000;

        // check that the balance of each Trustee has increase commensurate with the payout contract
        for (uint256 i = 0; i < recipients.length; i++) {
            assertEq(ecox.balanceOf(recipients[i]), balancesTrustees[i] + (payouts[i]*proposalVoteReward));
        }

        // check that the balance of the Policy contract has decreased by the sum of the payouts 
        uint256 payoutsum = 0;
        for (uint256 i = 0; i < payouts.length; i++) {
            payoutsum += payouts[i] * proposalVoteReward;
        }

        assertEq(ecox.balanceOf(address(policy)), balancePolicy + balanceTrustedNodes - payoutsum);


    }
}
