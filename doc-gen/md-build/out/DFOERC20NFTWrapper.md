## Contract ISuperSaiyanToken

* **Path:** out/DFOERC20NFTWrapper.sol
* **Version:** 1
* **Title:** SuperSaiyanToken

Super Saiya-jin Token is a ethItem Token Standard which includes capabilities to be used as a Voting Tokens for DFO. It is linked to a specific DFO through the Double Proxy, and every funcion that writes on the storage can be just triggered through a Proposal by the Token Holders of the linked DFO.
## Methods



### balanceOf(address,uint256)

Returns the amount of tokens of token type `id` owned by `account`. Requirements: - `account` cannot be the zero address.



### balanceOfBatch(address[],uint256[])

xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}. Requirements: - `accounts` and `ids` must have the same length.



### decimals(uint256)

Returns the decimals of the given token id

#### Params

- `objectId`: the id of the token whose decimals you want to know



### doubleProxy()

GET the Double Proxy of the linked DFO



### isApprovedForAll(address,address)

Returns true if `operator` is approved to transfer ``account``'s tokens. See {setApprovalForAll}.



### name(uint256)

Returns the name of the given token id

#### Params

- `objectId`: the id of the token whose name you want to know



### onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)

Handles the receipt of a multiple ERC1155 token types. This function is called at the end of a `safeBatchTransferFrom` after the balances have been updated. To accept the transfer(s), this must return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81, or its own function selector).

#### Params

- `data`: Additional data with no specified format
- `from`: The address which previously owned the token
- `ids`: An array containing ids of each token being transferred (order and length must match values array)
- `operator`: The address which initiated the batch transfer (i.e. msg.sender)
- `values`: An array containing amounts of each token being transferred (order and length must match ids array)

#### Returns

- `_0`: `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed



### onERC1155Received(address,address,uint256,uint256,bytes)

Handles the receipt of a single ERC1155 token type. This function is called at the end of a `safeTransferFrom` after the balance has been updated. To accept the transfer, this must return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61, or its own function selector).

#### Params

- `data`: Additional data with no specified format
- `from`: The address which previously owned the token
- `id`: The ID of the token being transferred
- `operator`: The address which initiated the transfer (i.e. msg.sender)
- `value`: The amount of tokens being transferred

#### Returns

- `_0`: `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed



### safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)

xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}. Emits a {TransferBatch} event. Requirements: - `ids` and `amounts` must have the same length. - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the acceptance magic value.



### safeTransferFrom(address,address,uint256,uint256,bytes)

Transfers `amount` tokens of token type `id` from `from` to `to`. Emits a {TransferSingle} event. Requirements: - `to` cannot be the zero address. - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}. - `from` must have a balance of tokens of type `id` of at least `amount`. - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the acceptance magic value.



### setApprovalForAll(address,bool)

Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`, Emits an {ApprovalForAll} event. Requirements: - `operator` cannot be the caller.



### setDoubleProxy(address)

SET the Double Proxy of the linked DFO This function can be called just by voting a Proposal in the Linked DFO

#### Params

- `newDoubleProxy`: represents the address of the new Double Proxy



### setUri(uint256,string)

SET the URI to locate the Metadata of the Token Id passed in input This function can be called just by voting a Proposal in the Linked DFO It raises the 'UriChanged' event

#### Params

- `objectId`: the Token Id whose Metadata uri to be set.
- `uri`: the new Metadata uri



### supportsInterface(bytes4)

Returns true if this contract implements the interface defined by `interfaceId`. See the corresponding https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section] to learn more about how these ids are created. This function call must use less than 30 000 gas.



### symbol(uint256)

Returns the symbol of the given token id

#### Params

- `objectId`: the id of the token whose symbol you want to know



### totalSupply(uint256)

Returns the total supply of the given token id

#### Params

- `objectId`: the id of the token whose availability you want to know



### uri(uint256)

Returns the uri of the given token id

#### Params

- `objectId`: the id of the token whose uri you want to know
