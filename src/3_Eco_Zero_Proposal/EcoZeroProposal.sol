import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";

contract EcoZeroProposal is Proposal {
    
    //L1 contracts
    address public immutable newECOImpl;

    ECO public immutable eco;
    
    //L2 contracts
    address public immutable newL2ECOImpl;

    

    constructor(
        address _newECOImpl,
        ECO _eco
        ) {
        newECOImpl = _newECOImpl;
        eco = _eco;
    }

    function name() public pure virtual override returns (string memory) {
        return "Zero Eco Balances";
    }

    function description()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return
            "Zeros Eco Balances in Advance of Token Migration";
    }

    function url() public pure override returns (string memory) {
        return
            "N/A";
    }

    function enacted(address _self) public virtual override{
        eco.setImplementation(newECOImpl);
    }

}  