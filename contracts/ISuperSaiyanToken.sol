// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../eth-item-token-standard/IEthItem.sol";

/**
 * @title SuperSaiyanToken
 * @dev Super Saiya-jin Token is a ethItem Token Standard which includes capabilities to be used as a Voting Tokens for DFO.
 * It is linked to a specific DFO through the Double Proxy, and every funcion that writes on the storage can be just triggered
 * through a Proposal by the Token Holders of the linked DFO.
 */
interface ISuperSaiyanToken is IEthItem {

    /**
     * @dev GET the Double Proxy of the linked DFO
     */
    function doubleProxy() external view returns(address);

    /**
     * @dev SET the Double Proxy of the linked DFO
     * This function can be called just by voting a Proposal in the Linked DFO
     * @param newDoubleProxy represents the address of the new Double Proxy
     */
    function setDoubleProxy(address newDoubleProxy) external;

    /**
     * @dev SET the URI to locate the Metadata of the Token Id passed in input
     * This function can be called just by voting a Proposal in the Linked DFO
     * It raises the 'UriChanged' event
     * @param objectId the Token Id whose Metadata uri to be set.
     * @param uri the new Metadata uri
     */
    function setUri(uint256 objectId, string calldata uri) external;

    event UriChanged(uint256 indexed objectId, string oldUri, string newUri);
}

interface IDoubleProxy {
    function proxy() external view returns(address);
}

interface IMVDProxy {
    function getToken() external view returns(address);
    function getStateHolderAddress() external view returns(address);
    function getMVDWalletAddress() external view returns(address);
    function getMVDFunctionalitiesManagerAddress() external view returns(address);
    function getMVDFunctionalityProposalManagerAddress() external view returns(address);
    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
}

interface IStateHolder {
    function setUint256(string calldata name, uint256 value) external returns(uint256);
    function getUint256(string calldata name) external view returns(uint256);
    function getBool(string calldata varName) external view returns (bool);
    function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);
}

interface IMVDFunctionalitiesManager {
    function isAuthorizedFunctionality(address functionality) external view returns(bool);
}