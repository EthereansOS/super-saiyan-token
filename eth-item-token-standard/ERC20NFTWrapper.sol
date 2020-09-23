// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

import "../node_modules/@openzeppelin/contracts/GSN/Context.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/utils/Address.sol";
import "./IERC20NFTWrapper.sol";
import "./IEthItem.sol";

contract ERC20NFTWrapper is Context, IERC20NFTWrapper {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

    string internal _name;
    string internal _symbol;
    uint256 internal _decimals;

    address internal _mainWrapper;
    uint256 internal _objectId;

    function init(uint256 objectId) public virtual override {
        require(_mainWrapper == address(0), "Init already called!");
        (_name, _symbol, _decimals) = IEthItem(_mainWrapper = msg.sender).getMintData(
            _objectId = objectId
        );
    }

    function mainWrapper() public virtual override view returns (address) {
        return _mainWrapper;
    }

    function objectId() public virtual override view returns (uint256) {
        return _objectId;
    }

    function name() public virtual override view returns (string memory) {
        return _name;
    }

    function symbol() public virtual override view returns (string memory) {
        return _symbol;
    }

    function decimals() public virtual override view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public virtual override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public virtual override view returns (uint256) {
        return _balances[account];
    }

    function mint(address owner, uint256 amount) public virtual override {
        require(msg.sender == _mainWrapper, "Unauthorized action!");
        _mint(owner, amount);
    }

    function burn(address owner, uint256 amount) public virtual override {
        require(
            msg.sender == _mainWrapper ||
                (IEthItem(_mainWrapper).source() == address(0) && msg.sender == owner),
            "Unauthorized action!"
        );
        _burn(owner, amount);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        virtual
        override
        view
        returns (uint256 allowanceAmount)
    {
        allowanceAmount = _allowances[owner][spender];
        if (allowanceAmount == 0 && IEthItem(_mainWrapper).isApprovedForAll(owner, spender)) {
            allowanceAmount = _totalSupply;
        }
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_msgSender() == _mainWrapper) {
            return true;
        }
        if (!IEthItem(_mainWrapper).isApprovedForAll(sender, _msgSender())) {
            _approve(
                sender,
                _msgSender(),
                _allowances[sender][_msgSender()].sub(
                    amount,
                    "ERC20: transfer amount exceeds allowance"
                )
            );
        }
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        IEthItem(_mainWrapper).emitTransferSingleEvent(
            _msgSender(),
            sender,
            recipient,
            _objectId,
            amount
        );
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
