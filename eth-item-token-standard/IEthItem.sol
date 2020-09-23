// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "./IERC1155Views.sol";
import "./IERC20NFTWrapper.sol";
import "./IERC1155Data.sol";

interface IEthItem is IERC1155, IERC1155Receiver, IERC1155Views, IERC1155Data {
    function init(
        address model,
        address source,
        string calldata name,
        string calldata symbol
    ) external;

    function fromDecimals(uint256 objectId, uint256 amount) external view returns (uint256);

    function toDecimals(uint256 objectId, uint256 amount) external view returns (uint256);

    function getMintData(uint256 objectId)
        external
        view
        returns (
            string memory,
            string memory,
            uint256
        );

    function getModel() external view returns (address);

    function source() external view returns (address);

    function asERC20(uint256 objectId) external view returns (IERC20NFTWrapper);

    function emitTransferSingleEvent(
        address sender,
        address from,
        address to,
        uint256 objectId,
        uint256 amount
    ) external;

    function mint(uint256 amount, string calldata partialUri) external returns (uint256, address);

    function burn(
        uint256 objectId,
        uint256 amount,
        bytes calldata data
    ) external;

    function burnBatch(
        uint256[] calldata objectIds,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;

    event Mint(uint256 objectId, address tokenAddress);
}
