pragma solidity 0.5.4;

import "./ERC721.sol";
import "./ICryptoItems.sol";

contract ERC721ToCryptoItem {

    // Replace the following variables with the correct contracts and Token ID
    address public erc721ContractAddress = 0x0;
    address public erc1155ContractAddress = 0x0;
    uint256 public erc721BurnAddress = 0x0000000000000000000000000000000000000000; // This can optionally be replaced with a smart contract address or recipient address if burning is not desired
    uint256 public erc1155BaseId = 0x0;
    address public previousCreator = 0x0;

    event Convert(uint256 indexed _srcId, address indexed _destId);

    function convert(uint256 _srcId) external returns (uint256 destId) {
        if(previousCreator == 0x0) revert("Inactive");

        // Transfer the ERC-721 token to the burn address
        ERC721 erc721Contract = ERC721(erc721ContractAddress);
        erc721Contract.transferFrom(msg.sender, erc721BurnAddress, _srcId);

        // Mint the ERC-1155 token to the sender's address
        ERC721 erc1155Contract = ICryptoItems(erc1155ContractAddress);
        erc1155Contract.mintNonFungible(erc1155BaseId, msg.sender);

        // Emit event signifying completion
        emit Convert(_srcId, destId);
    }

    function acceptAssignment() external {

        previousCreator = msg.sender;
    }

    function assign() external {

        previousCreator = 0x0;
    }
}