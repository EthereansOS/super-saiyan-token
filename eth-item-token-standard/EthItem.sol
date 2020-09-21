// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

import "./IEthItem.sol";
import "./IERC20NFTWrapper.sol";

/**
 * @title EthItem - An improved ERC1155 token with ERC20 trading capabilities.
 * @dev In the EthItem standard, there is no a centralized storage where to save every objectId info.
 * In fact every NFT data is saved in a specific ERC20 token that can also work as a standalone one, and let transfer parts of an atomic object.
 * The ERC20 represents a unique Token Id, and its supply represents the entire supply of that Token Id.
 * You can instantiate a EthItem as a brand-new one, or as a wrapper for pre-existent classic ERC1155 NFT.
 * In the first case, you can introduce some particular permissions to mint new tokens.
 * In the second case, you need to send your NFTs to the Wrapped EthItem (using the classic safeTransferFrom or safeBatchTransferFrom methods)
 * and it will create a brand new ERC20 Token or mint new supply (in the case some tokens with the same id were transfered before yours).
 */
contract EthItem is IEthItem, Context, ERC165 {
    using SafeMath for uint256;
    using Address for address;

    bytes4 internal constant _INTERFACEobjectId_ERC1155 = 0xd9b67a26;

    address private _source;

    string internal _name;
    string internal _symbol;

    mapping(uint256 => string) internal _objectUris;

    bool private _supportsName;
    bool private _supportsSymbol;
    bool private _supportsDecimals;

    mapping(uint256 => address) internal _dest;
    mapping(address => bool) internal _isMine;

    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    address internal _model;

    /**
     * @dev Constructor
     * When you create a EthItem, you can specify if you want to create a brand new one, passing the classic data like name, symbol, amd URI,
     * or wrap a pre-existent ERC1155 NFT, passing its contract address.
     * You can use just one of the two modes at the same time.
     * In both cases, a ERC20 token address is mandatory. It will be used as a model to be cloned for every minted NFT.
     * @param model the address of the ERC20 pre-deployed model. I will not be used in the procedure, but just cloned as a brand-new one every time a new NFT is minted.
     * @param source the address of the ERC1155 NFT to be wrapped. If you want to create a brand new NFT, this value must be address(0).
     * @param name the name of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
     * @param symbol the symbol of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
     */
    constructor(
        address model,
        address source,
        string memory name,
        string memory symbol
    ) public {
        if(model != address(0)) {
            init(model, source, name, symbol);
        }
    }

    /**
     * @dev Utility method which contains the logic of the constructor.
     * This is a useful trick to instantiate a contract when it is cloned.
     */
    function init(
        address model,
        address source,
        string memory name,
        string memory symbol
    ) public virtual override {
        require(
            _model == address(0),
            "Init already called!"
        );

        require(
            model != address(0),
            "Model should be a valid ethereum address"
        );
        _model = model;

        _source = source;

        require(
            _source != address(0) || keccak256(bytes(name)) != keccak256(""),
            "At least a source contract or a name must be set"
        );
        require(
            _source != address(0) || keccak256(bytes(symbol)) != keccak256(""),
            "At least a source contract or a symbol must be set"
        );

        _registerInterface(this.onERC1155Received.selector);
        _registerInterface(this.onERC1155BatchReceived.selector);
        bool safeBatchTransferFrom = _checkAndInsertSelector(
            this.safeBatchTransferFrom.selector
        );
        bool cumulativeInterface = _checkAndInsertSelector(
            _INTERFACEobjectId_ERC1155
        );
        require(
            _source == address(0) ||
                safeBatchTransferFrom ||
                cumulativeInterface,
            "Looks like you're not wrapping a correct ERC1155 Token"
        );
        _checkAndInsertSelector(this.balanceOf.selector);
        _checkAndInsertSelector(this.balanceOfBatch.selector);
        _checkAndInsertSelector(this.setApprovalForAll.selector);
        _checkAndInsertSelector(this.isApprovedForAll.selector);
        _checkAndInsertSelector(this.safeTransferFrom.selector);
        _checkAndInsertSelector(this.uri.selector);
        _checkAndInsertSelector(this.totalSupply.selector);
        _supportsName = _checkAndInsertSelector(0x00ad800c); //name(uint256)
        _supportsSymbol = _checkAndInsertSelector(0x4e41a1fb); //symbol(uint256)
        _supportsDecimals = _checkAndInsertSelector(this.decimals.selector);
        _supportsDecimals = _source == address(0) ? false : _supportsDecimals;
        _setAndCheckNameAndSymbol(name, symbol);
    }

    /**
     * @dev Mint
     * If the EthItem does not wrap a pre-existent NFT, this call is used to mint new NFTs, according to the permission rules provided by the Token creator.
     * @param amount The amount of tokens to be created. It must be greater than 1 unity.
     * @param objectUri The Uri to locate this new token's metadata.
     */
    function mint(uint256 amount, string memory objectUri)
        public
        virtual
        override
        returns (uint256 objectId, address tokenAddress)
    {
        require(_source == address(0), "Cannot mint unexisting tokens");
        require(
            keccak256(bytes(objectUri)) != keccak256(""),
            "Uri cannot be empty"
        );
        (objectId, tokenAddress) = _mint(msg.sender, 0, amount, true);
        _objectUris[objectId] = objectUri;
    }

    /**
     * @dev Burn
     * You can choose to burn your NFTs.
     * In case this Token wraps a pre-existent ERC1155 NFT, you will receive the wrapped NFTs.
     */
    function burn(
        uint256 objectId,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        asERC20(objectId).burn(msg.sender, toDecimals(objectId, amount));
        if (_source != address(0)) {
            IERC1155(_source).safeTransferFrom(
                address(this),
                msg.sender,
                objectId,
                amount,
                data
            );
        }
    }

    /**
     * @dev Burn Batch
     * Same as burn, but for multiple NFTs at the same time
     */
    function burnBatch(
        uint256[] memory objectIds,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        for (uint256 i = 0; i < objectIds.length; i++) {
            asERC20(objectIds[i]).burn(
                msg.sender,
                toDecimals(objectIds[i], amounts[i])
            );
        }
        if (_source != address(0)) {
            IERC1155(_source).safeBatchTransferFrom(
                address(this),
                msg.sender,
                objectIds,
                amounts,
                data
            );
        }
    }

    /**
     * @dev classic ERC-1155 onERC1155Received hook.
     * This method can be called only by the wrapped classic ERC1155 NFT, if it exists.
     * Call this method means that someone transfer original NFTs to receive wrapped ones.
     * So this method will provide brand new NFTs
     */
    function onERC1155Received(
        address,
        address owner,
        uint256 objectId,
        uint256 amount,
        bytes memory
    ) public virtual override returns (bytes4) {
        require(msg.sender == _source, "Unauthorized action!");
        _mint(owner, objectId, amount, false);
        return this.onERC1155Received.selector;
    }

    /**
     * @dev classic ERC-1155 onERC1155BatchReceived hook.
     * Same as onERC1155Received, but for multiple tokens at the same time
     */
    function onERC1155BatchReceived(
        address,
        address owner,
        uint256[] memory objectIds,
        uint256[] memory amounts,
        bytes memory
    ) public virtual override returns (bytes4) {
        require(msg.sender == _source, "Unauthorized action!");
        for (uint256 i = 0; i < objectIds.length; i++) {
            _mint(owner, objectIds[i], amounts[i], false);
        }
        return this.onERC1155BatchReceived.selector;
    }

    /**
     * @dev this method sends the correct creation parameters for the new ERC-20 to be minted.
     * It takes thata from the wrapped ERC1155 NFT or from the parameters passed at construction time.
     */
    function getMintData(uint256 objectId)
        public
        virtual
        override
        view
        returns (
            string memory name,
            string memory symbol,
            uint256 decimals
        )
    {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        if (
            _source != address(0) &&
            (_supportsName || _supportsSymbol || _supportsDecimals)
        ) {
            IERC1155Views views = IERC1155Views(_source);
            name = _supportsName ? views.name(objectId) : name;
            symbol = _supportsSymbol ? views.symbol(objectId) : symbol;
            decimals = _supportsDecimals ? views.decimals(objectId) : decimals;
        }
    }

    /**
     * @dev get the address of the ERC20 Contract used as a model
     */
    function getModel() public virtual override view returns (address) {
        return _model;
    }

    /**
     * @dev Utility method to convert from decimals notation the original NFT (if any) to the ERC20 ones.
     */
    function fromDecimals(uint256 objectId, uint256 amount)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return _supportsDecimals ? amount : (amount / (10**decimals(objectId)));
    }

    /**
     * @dev Utility method to convert to decimals notation the original NFT (if any) to the ERC20 ones.
     */
    function toDecimals(uint256 objectId, uint256 amount)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return _supportsDecimals ? amount : (amount * (10**decimals(objectId)));
    }

    /**
     * @dev Returns the address of the wrapped ERC1155 NFT (if any)
     */
    function source() public virtual override view returns (address) {
        return _source;
    }

    /**
     * @dev Gives back the address of the ERC20 Token representing this Token Id
     */
    function asERC20(uint256 objectId)
        public
        virtual
        override
        view
        returns (IERC20NFTWrapper)
    {
        return IERC20NFTWrapper(_dest[objectId]);
    }

    /**
     * @dev Returns the total supply of the given token id
     * @param objectId the id of the token whose availability you want to know
     */
    function totalSupply(uint256 objectId)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return fromDecimals(objectId, asERC20(objectId).totalSupply());
    }

    /**
     * @dev Returns the name of the given token id
     * @param objectId the id of the token whose name you want to know
     */
    function name(uint256 objectId)
        public
        virtual
        override
        view
        returns (string memory)
    {
        return asERC20(objectId).name();
    }

    function name() public virtual override view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the given token id
     * @param objectId the id of the token whose symbol you want to know
     */
    function symbol(uint256 objectId)
        public
        virtual
        override
        view
        returns (string memory)
    {
        return asERC20(objectId).symbol();
    }

    function symbol() public virtual override view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the decimals of the given token id
     * @param objectId the id of the token whose decimals you want to know
     */
    function decimals(uint256 objectId)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return asERC20(objectId).decimals();
    }

    /**
     * @dev Returns the uri of the given token id
     * @param objectId the id of the token whose uri you want to know
     */
    function uri(uint256 objectId)
        public
        virtual
        override
        view
        returns (string memory)
    {
        return
            _source == address(0)
                ? _objectUris[objectId]
                : IERC1155Views(_source).uri(objectId);
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function balanceOf(address account, uint256 objectId)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return fromDecimals(objectId, asERC20(objectId).balanceOf(account));
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory objectIds
    ) public virtual override view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; i++) {
            balances[i] = balanceOf(accounts[i], objectIds[i]);
        }
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        address sender = _msgSender();
        require(
            sender != operator,
            "ERC1155: setting approval status for self"
        );

        _operatorApprovals[sender][operator] = approved;
        emit ApprovalForAll(sender, operator, approved);
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function isApprovedForAll(address account, address operator)
        public
        virtual
        override
        view
        returns (bool)
    {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 objectId,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        address operator = _msgSender();

        asERC20(objectId).transferFrom(from, to, toDecimals(objectId, amount));

        emit TransferSingle(operator, from, to, objectId, amount);

        _doSafeTransferAcceptanceCheck(
            operator,
            from,
            to,
            objectId,
            amount,
            data
        );
    }

    /**
     * @dev Classic ERC1155 Standard Method
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory objectIds,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        for (uint256 i = 0; i < objectIds.length; i++) {
            asERC20(objectIds[i]).transferFrom(
                from,
                to,
                toDecimals(objectIds[i], amounts[i])
            );
        }

        address operator = _msgSender();

        emit TransferBatch(operator, from, to, objectIds, amounts);

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            from,
            to,
            objectIds,
            amounts,
            data
        );
    }

    function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) public override {
        require(_dest[objectId] == msg.sender, "Unauthorized Action!");
        uint256 entireAmount = fromDecimals(objectId, amount);
        if(entireAmount == 0) {
            return;
        }
        emit TransferSingle(sender, from, to, objectId, entireAmount);
    }

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    id,
                    amount,
                    data
                )
            returns (bytes4 response) {
                if (
                    response != IERC1155Receiver(to).onERC1155Received.selector
                ) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155BatchReceived(
                    operator,
                    from,
                    ids,
                    amounts,
                    data
                )
            returns (bytes4 response) {
                if (
                    response !=
                    IERC1155Receiver(to).onERC1155BatchReceived.selector
                ) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _checkAndInsertSelector(bytes4 selector)
        internal
        virtual
        returns (bool response)
    {
        if (_source == address(0)) {
            _registerInterface(selector);
            return true;
        }
        try ERC165(_source).supportsInterface(selector) returns (bool res) {
            if (response = res) {
                _registerInterface(selector);
            }
        } catch {}
    }

    function _clone(address original) internal returns (address copy) {
        assembly {
            mstore(
                0,
                or(
                    0x5880730000000000000000000000000000000000000000803b80938091923cF3,
                    mul(original, 0x1000000000000000000)
                )
            )
            copy := create(0, 0, 32)
            switch extcodesize(copy)
                case 0 {
                    invalid()
                }
        }
    }

    function _mint(
        address from,
        uint256 oldObjectId,
        uint256 amount,
        bool generateObjectId
    ) internal virtual returns (uint256, address) {
        uint256 objectId = oldObjectId;
        IERC20NFTWrapper wrapper = IERC20NFTWrapper(_dest[objectId]);
        if (_dest[objectId] == address(0) || generateObjectId) {
            require(
                amount > _getTokenUnity(objectId),
                "You need to pass more than a token"
            );
            wrapper = IERC20NFTWrapper(_clone(getModel()));
            if(generateObjectId) {
                objectId = uint256(address(wrapper));
            }
            wrapper.init(objectId);
            _isMine[_dest[objectId] = address(wrapper)] = true;
            emit Mint(objectId, address(wrapper));
        }
        wrapper.mint(from, _convertForMint(objectId, amount));
        emit TransferSingle(address(this), address(0), from, objectId, amount);
        return (objectId, address(wrapper));
    }

    function _getTokenUnity(uint256 objectId)
        internal
        virtual
        view
        returns (uint256)
    {
        if (_source == address(0)) {
            return (10**18);
        }
        if (_supportsDecimals) {
            return (10**IERC1155Views(_source).decimals(objectId));
        }
        return 1;
    }

    function _convertForMint(uint256 objectId, uint256 amount)
        internal
        virtual
        view
        returns (uint256)
    {
        if (_source != address(0) && _supportsDecimals) {
            return amount * (10**IERC1155Views(_source).decimals(objectId));
        }
        return amount;
    }

    function _setAndCheckNameAndSymbol(
        string memory inputName,
        string memory inputSymbol
    ) internal virtual {
        _name = inputName;
        _symbol = inputSymbol;
        if (_source != address(0)) {
            IERC1155Data data = IERC1155Data(_source);
            try data.name() returns (string memory n) {
                _name = n;
            } catch {}
            try data.symbol() returns (string memory s) {
                _symbol = s;
            } catch {}
        }
        require(keccak256(bytes(_name)) != keccak256(""), "Name is mandatory");
        require(
            keccak256(bytes(_symbol)) != keccak256(""),
            "Symbol is mandatory"
        );
    }
}
