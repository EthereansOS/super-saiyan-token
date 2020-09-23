// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

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

// File: contracts/IDFOERC20NFTWrapper.sol

// SPDX_License_Identifier: MIT

pragma solidity >=0.7.0;


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