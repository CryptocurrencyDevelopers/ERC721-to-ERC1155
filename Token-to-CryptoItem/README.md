# Token to CryptoItem

## Description
This smart contract will "eat" an existing ERC721 token and replace it by minting a new ERC1155 CryptoItem token.

If needed, an ERC20 version can be easily created with the same concept.

## Requirements
* The appropriate amount of ENJ must be escrowed in the CryptoItems contract. I recommend pre-loading it using the full Initial Supply on creation for ease of use.
* User must give approval for this smart contract to manage the ERC721 token's contract on their behalf.
* Creator of the ERC-1155 token must "assign" the token ID to this contract for minting to work. The assignment can be revoked at any time.
