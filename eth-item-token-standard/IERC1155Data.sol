// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IERC1155Data {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);
}