## Contract IDFOERC20NFTWrapper

* **Path:** out/IDFOERC20NFTWrapper.sol
* **Version:** 1
* **Title:** IDFOERC20NFTWrapper

This ERC20 Token represents the model of every Super Saiya-jin Token will implement for every minted NFT It just implements the same funcions of the VotingToken of the DFOProtocol, to let it became a Voting Token
## Methods



### allowance(address,address)

Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner` through {transferFrom}. This is zero by default. This value changes when {approve} or {transferFrom} are called.



### approve(address,uint256)

Sets `amount` as the allowance of `spender` over the caller's tokens. Returns a boolean value indicating whether the operation succeeded. IMPORTANT: Beware that changing an allowance with this method brings the risk that someone may use both the old and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 Emits an {Approval} event.



### balanceOf(address)

Returns the amount of tokens owned by `account`.



### getProxy()

GET the Proxy



### mint(uint256)

Mint functionality of the voting token



### setProxy()

SET the Proxy



### totalSupply()

Returns the amount of tokens in existence.



### transfer(address,uint256)

Moves `amount` tokens from the caller's account to `recipient`. Returns a boolean value indicating whether the operation succeeded. Emits a {Transfer} event.



### transferFrom(address,address,uint256)

Moves `amount` tokens from `sender` to `recipient` using the allowance mechanism. `amount` is then deducted from the caller's allowance. Returns a boolean value indicating whether the operation succeeded. Emits a {Transfer} event.
