import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {TrustedNodes} from "currency-1.5/governance/monetary/TrustedNodes.sol";

contract TrusteePayout is Proposal {
    
    address[] public recipients;

    uint256[] public payouts;

    ECOx public immutable ecox; 
    
    address public immutable trustedNodes;

    constructor(
        address[] memory _recipients,
        uint256[] memory _payouts,
        ECOx _ecox,
        address _trustedNodes
        ) {
        require(_recipients.length == _payouts.length, "Recipients and payouts arrays must be the same length");
        recipients = _recipients;
        payouts = _payouts;
        ecox = _ecox;
        trustedNodes = _trustedNodes;
    }

    function name() public pure virtual override returns (string memory) {
        return "Trustee Payout Proposal";
    }

    function description()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return
            "Pays out Trustees for their first term due to a smart contract bug";
    }

    /** A URL where more details can be found.
     */
    function url() public pure override returns (string memory) {
        return
            "https://forum.eco.com/t/the-next-eco-era-trustee-payouts-fix/404";
    }

    function returnRecipients() public view returns (address[] memory) {
        return recipients;
    }
    function returnPayouts() public view returns (uint256[] memory) {
        return payouts;
    }

    function enacted(address _self) public virtual override{

        // Add the contract to the minter and burner list   
        ecox.updateMinters(address(this), true);
        ecox.updateBurners(address(this), true);

        // Query the balance of the TrustedNodes contract
        uint256 balance = ecox.balanceOf(trustedNodes);

        // Burn the balance of the TrustedNodes contract
        ecox.burn(trustedNodes, balance);

        // Mint the balance of the TrustedNodes contract to root policy
        ecox.mint(address(this), balance);

        // access the recipeints and payouts arrays
        address[] memory _recipients = TrusteePayout(_self).returnRecipients();
        uint256[] memory _payouts = TrusteePayout(_self).returnPayouts();

        for (uint256 i = 0; i < _recipients.length; i++) {
            ecox.transfer(_recipients[i], _payouts[i] * TrustedNodes(trustedNodes).voteReward());
        }
    }

}  