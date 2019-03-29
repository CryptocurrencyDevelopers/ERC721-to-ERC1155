# Token to CryptoItem

## Description
This smart contract will "eat" an existing ERC721 token and replace it by minting a new ERC1155 CryptoItem token.

The user can simply send the token to this contract address and the onERC721Received function should handle the minting.

## Requirements
* The appropriate amount of ENJ must be escrowed in the CryptoItems contract. I recommend pre-loading it using the full Initial Supply when creating the CryptoItems token.
* Creator of the ERC-1155 token must "assign" the token ID to this contract for minting to work. The assignment can be revoked at any time.
