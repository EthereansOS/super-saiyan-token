// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../eth-item-token-standard/IERC20NFTWrapper.sol";

interface IDFOERC20NFTWrapper is IERC20NFTWrapper {
    function mint(uint256 amount) external;
    function getProxy() external view returns (address);
    function setProxy() external;
}

interface IMVDFunctionalityProposalManager {
    function isValidProposal(address proposal) external view returns (bool);
}