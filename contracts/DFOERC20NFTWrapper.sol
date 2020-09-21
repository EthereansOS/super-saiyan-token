// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./IDFOERC20NFTWrapper.sol";
import "./ISuperSaiyanToken.sol";
import "../eth-item-token-standard/ERC20NFTWrapper.sol";

/**
 * @title SuperSaiyanToken
 */
contract DFOERC20NFTWrapper is IDFOERC20NFTWrapper, ERC20NFTWrapper {

    function mint(uint256 amount) public virtual override {
        IMVDProxy proxy = IMVDProxy(getProxy());
        require(
            IMVDFunctionalitiesManager(
                proxy.getMVDFunctionalitiesManagerAddress()
            )
                .isAuthorizedFunctionality(msg.sender),
            "Unauthorized action!"
        );
        super._mint(address(proxy), amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override(IERC20, ERC20NFTWrapper) returns (bool) {
        _transfer(sender, recipient, amount);
        address txSender = _msgSender();
        if (txSender == _mainWrapper || ISuperSaiyanToken(_mainWrapper).isApprovedForAll(
                sender,
                txSender
            )) {
            return true;
        }
        address proxy = getProxy();
        if (
            proxy == address(0) ||
            !(IMVDFunctionalityProposalManager(
                IMVDProxy(proxy).getMVDFunctionalityProposalManagerAddress()
            )
                .isValidProposal(txSender) && recipient == txSender)
        ) {
            _approve(
                sender,
                txSender,
                _allowances[sender][txSender] = _allowances[sender][txSender].sub(
                    amount,
                    "ERC20: transfer amount exceeds allowance"
                )
            );
        }
        return true;
    }

    receive() external payable {
        revert("ETH not accepted");
    }

    function getProxy() public override view returns (address) {
        address doubleProxy = ISuperSaiyanToken(_mainWrapper).doubleProxy();
        return doubleProxy == address(0) ? address(0) : IDoubleProxy(doubleProxy).proxy();
    }

    function setProxy() public override {
    }
}
