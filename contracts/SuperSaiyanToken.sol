// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./ISuperSaiyanToken.sol";
import "../eth-item-token-standard/EthItem.sol";

contract SuperSaiyanToken is ISuperSaiyanToken, EthItem(address(0), address(0), "", "") {

    address private _doubleProxy;

    constructor(
        address model,
        address doubleProxy,
        string memory name,
        string memory symbol
    ) public {
        if(model != address(0)) {
            init(model, doubleProxy, name, symbol);
        }
    }

    function init(
        address model,
        address doubleProxy,
        string memory name,
        string memory symbol
    ) public override(IEthItem, EthItem) {
        super.init(model, address(0), name, symbol);
        _doubleProxy = doubleProxy;
    }

    modifier byDFO {
        if(_doubleProxy != address(0)) {
            require(IMVDFunctionalitiesManager(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");
        }
        _;
    }

    function doubleProxy() public override view returns(address) {
        return _doubleProxy;
    }

    function setDoubleProxy(address newDoubleProxy) public override byDFO {
        _doubleProxy = newDoubleProxy;
    }

    function mint(uint256 amount, string memory objectUri)
        public
        virtual
        override(IEthItem, EthItem)
        byDFO
        returns (uint256 objectId, address tokenAddress)
    {
        (objectId, tokenAddress) = super.mint(amount, objectUri);
        emit UriChanged(objectId, "", objectUri);
    }

    function setUri(uint256 objectId, string memory newUri) public byDFO override {
        emit UriChanged(objectId, _objectUris[objectId], newUri);
        _objectUris[objectId] = newUri;
    }
}