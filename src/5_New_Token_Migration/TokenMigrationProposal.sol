import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";

contract TokenMigrationProposal is Proposal {

    //L1 Addresses
    address public ecox; // 0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a
    address public secox; // 0x3a16f2Fee32827a9E476d0c87E454aB7C75C92D7
    address public newToken; // TBD
    address public migrationContract; // TBD

    //L2 Addresses
    address public staticMarket; // 0x6085e45604956A724556135747400e32a0D6603A
    address public migrationContractOP; // TBD
    address public newTokenOP; // TBD

    // reference proposal : https://etherscan.io/address/0x80CC5F92F93F5227b7057828e223Fc5BAD71b2E7#code 


    constructor(address _staticMarket, address _eco, address _newToken) {
        staticMarket = _staticMarket;
        eco = _eco;
        newToken = _newToken;
    }

// MAINNET
// need the address of the migration contract
// need to give burn permission on ECOx to the migration contract
// need to give mint permission on the new token to the migration contract
// give permission to the migration contract to own ECOX
// give permission to the migration contract to own sECOx


// OPTIMISM
// send message to static market to transfer the tokens to the optimism migration contract
// send message to the ECOx contract on Optimism to give burn permission to the migration contract on Optimism

}
