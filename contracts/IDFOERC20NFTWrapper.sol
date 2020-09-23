// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "../eth-item-token-standard/IERC20NFTWrapper.sol";

/**
 * @title IDFOERC20NFTWrapper
 * @dev This ERC20 Token represents the model of every Super Saiya-jin Token will implement for every minted NFT
 * It just implements the same funcions of the VotingToken of the DFOProtocol, to let it became a Voting Token
 */
interface IDFOERC20NFTWrapper is IERC20NFTWrapper {
    /**
     * @dev Mint functionality of the voting token
     */
    function mint(uint256 amount) external;

    /**
     * @dev GET the Proxy
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the Proxy
     */
    function setProxy() external;
}

interface IMVDFunctionalityProposalManager {
    function isValidProposal(address proposal) external view returns (bool);
}
