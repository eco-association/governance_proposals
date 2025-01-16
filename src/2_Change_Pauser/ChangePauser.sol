import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {ECO} from "currency-1.5/currency/ECO.sol";


contract ChangePauser is Proposal {

    ECOx public immutable ecox; 

    ECO public immutable eco;

    address public immutable newPauser;
    
    constructor(
        ECOx _ecox,
        ECO _eco,
        address _newPauser
        ) {
        ecox = _ecox;
        eco = _eco;
        newPauser = _newPauser;
    }

    function name() public pure virtual override returns (string memory) {
        return "Change Pauser";
    }

    function description()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return
            "Changes the pauser of the ECOx contract";
    }

    function url() public pure override returns (string memory) {
        return
            "https://forum.eco.com/t/the-next-eco-era-governance-updates-the-eco-foundation/406";
    }

    function returnNewPauser() public view returns (address) {
        return newPauser;
    }

    function enacted(address _self) public virtual override{
        ecox.setPauser(newPauser);
        eco.setPauser(newPauser);
    }

}  