// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../eth-item-token-standard/IEthItem.sol";

interface ISuperSaiyanToken is IEthItem {

    function doubleProxy() external view returns(address);
    function setDoubleProxy(address newDoubleProxy) external;
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