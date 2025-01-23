import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";
import {L1ECOBridge} from "op-eco/bridge/L1ECOBridge.sol";


contract EcoZeroProposal is Proposal {
    
    //L1 contracts
    address public immutable newECOImpl;
    ECO public immutable eco;
    L1ECOBridge public immutable l1ECOBridge;
    
    //L2 contracts
    address public immutable newL2ECOImpl;

    //other
    uint32 public immutable l2gas;

    constructor(
        address _newECOImpl,
        address _newL2ECOImpl,
        L1ECOBridge _l1ECOBridge,
        ECO _eco,
        uint32 _l2gas
        ) {
        newECOImpl = _newECOImpl;
        newL2ECOImpl = _newL2ECOImpl;
        l1ECOBridge = _l1ECOBridge;
        eco = _eco;
        l2gas = _l2gas;
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
        l1ECOBridge.upgradeECO(newL2ECOImpl, l2gas);
    }

}  