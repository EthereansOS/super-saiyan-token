// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20NFTWrapper is IERC20 {
    function init(uint256 objectId) external;

    function mainWrapper() external view returns (address);

    function objectId() external view returns (uint256);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);

    function mint(address owner, uint256 amount) external;

    function burn(address owner, uint256 amount) external;
}
