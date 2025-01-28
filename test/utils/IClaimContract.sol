// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface IClaimContract {
    error ClaimDeadlineExpired();
    error CliffNotMet();
    error EmptyVestingBalance();
    error InvalidFee();
    error InvalidPoints();
    error InvalidProof();
    error InvalidProofDepth();
    error InvalidReleaseCaller();
    error InvalidSignature();
    error SignatureExpired();
    error TokensAlreadyClaimed();
    error UnverifiedClaim();

    event Claim(string socialID, address indexed addr, uint256 eco, uint256 ecox);
    event InitializeEcoClaim();
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ReleaseVesting(
        address indexed addr, address indexed gasPayer, uint256 ecoBalance, uint256 vestedEcoXBalance, uint256 feeAmount
    );

    function CLAIMABLE_PERIOD() external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function POINTS_MULTIPLIER() external view returns (uint256);
    function POINTS_TO_ECOX_RATIO() external view returns (uint256);
    function VESTING_DIVIDER() external view returns (uint256);
    function VESTING_PERIOD() external view returns (uint256);
    function _claimBalances(string memory)
        external
        view
        returns (address recipient, uint256 points, uint256 claimTime);
    function _claimableEndTime() external view returns (uint256);
    function _claimedBalances(string memory) external view returns (bool);
    function _deployTimestamp() external view returns (uint256);
    function _eco() external view returns (address);
    function _ecoID() external view returns (address);
    function _ecoX() external view returns (address);
    function _initialInflationMultiplier() external view returns (uint256);
    function _pointsMerkleRoot() external view returns (bytes32);
    function _proofDepth() external view returns (uint256);
    function _trustedVerifier() external view returns (address);
    function _vestedMultiples(uint256) external view returns (uint256);
    function claimTokens(bytes32[] memory proof, string memory socialID, uint256 points) external;
    function claimTokensOnBehalf(
        bytes32[] memory proof,
        string memory socialID,
        uint256 points,
        address recipient,
        uint256 feeAmount,
        uint256 deadline,
        bytes memory recipientSig
    ) external;
    function nonces(string memory socialID) external view returns (uint256);
    function owner() external view returns (address);
    function releaseTokens(string memory socialID) external;
    function releaseTokensOnBehalf(
        string memory socialID,
        address recipient,
        uint256 feeAmount,
        uint256 deadline,
        bytes memory recipientSig
    ) external;
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
}
