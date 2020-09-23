// File: @openzeppelin/contracts/introspection/IERC165.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;


/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}

// File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;


/**
 * _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {

    /**
        @dev Handles the receipt of a single ERC1155 token type. This function is
        called at the end of a `safeTransferFrom` after the balance has been updated.
        To accept the transfer, this must return
        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
        (i.e. 0xf23a6e61, or its own function selector).
        @param operator The address which initiated the transfer (i.e. msg.sender)
        @param from The address which previously owned the token
        @param id The ID of the token being transferred
        @param value The amount of tokens being transferred
        @param data Additional data with no specified format
        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external
        returns(bytes4);

    /**
        @dev Handles the receipt of a multiple ERC1155 token types. This function
        is called at the end of a `safeBatchTransferFrom` after the balances have
        been updated. To accept the transfer(s), this must return
        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
        (i.e. 0xbc197c81, or its own function selector).
        @param operator The address which initiated the batch transfer (i.e. msg.sender)
        @param from The address which previously owned the token
        @param ids An array containing ids of each token being transferred (order and length must match values array)
        @param values An array containing amounts of each token being transferred (order and length must match ids array)
        @param data Additional data with no specified format
        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external
        returns(bytes4);
}

// File: eth-item-token-standard/IERC1155Views.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;

/**
 * @title IERC1155Views - An optional utility interface to improve the ERC-1155 Standard.
 * @dev This interface introduces some additional capabilities for ERC-1155 Tokens.
 */
interface IERC1155Views {
    /**
     * @dev Returns the total supply of the given token id
     * @param objectId the id of the token whose availability you want to know
     */
    function totalSupply(uint256 objectId) external view returns (uint256);

    /**
     * @dev Returns the name of the given token id
     * @param objectId the id of the token whose name you want to know
     */
    function name(uint256 objectId) external view returns (string memory);

    /**
     * @dev Returns the symbol of the given token id
     * @param objectId the id of the token whose symbol you want to know
     */
    function symbol(uint256 objectId) external view returns (string memory);

    /**
     * @dev Returns the decimals of the given token id
     * @param objectId the id of the token whose decimals you want to know
     */
    function decimals(uint256 objectId) external view returns (uint256);

    /**
     * @dev Returns the uri of the given token id
     * @param objectId the id of the token whose uri you want to know
     */
    function uri(uint256 objectId) external view returns (string memory);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: eth-item-token-standard/IERC20NFTWrapper.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;


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

// File: eth-item-token-standard/IERC1155Data.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;

interface IERC1155Data {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);
}

// File: eth-item-token-standard/IEthItem.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;






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

// File: contracts/ISuperSaiyanToken.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;


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
    function doubleProxy() external view returns (address);

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
    function proxy() external view returns (address);
}

interface IMVDProxy {
    function getToken() external view returns (address);

    function getStateHolderAddress() external view returns (address);

    function getMVDWalletAddress() external view returns (address);

    function getMVDFunctionalitiesManagerAddress() external view returns (address);

    function getMVDFunctionalityProposalManagerAddress() external view returns (address);

    function submit(string calldata codeName, bytes calldata data)
        external
        payable
        returns (bytes memory returnData);
}

interface IStateHolder {
    function setUint256(string calldata name, uint256 value) external returns (uint256);

    function getUint256(string calldata name) external view returns (uint256);

    function getBool(string calldata varName) external view returns (bool);

    function clear(string calldata varName)
        external
        returns (string memory oldDataType, bytes memory oldVal);
}

interface IMVDFunctionalitiesManager {
    function isAuthorizedFunctionality(address functionality) external view returns (bool);
}