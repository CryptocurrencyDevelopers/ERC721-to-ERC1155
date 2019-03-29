pragma solidity 0.5.4;

import "./ERC721.sol";
import "./ICryptoItems.sol";

contract ERC721ToCryptoItem {

    bool public active = false;
    address public originalCreator = address(0);
    address public erc721ContractAddress;
    address public erc1155ContractAddress;
    uint256 public erc1155BaseId;

    // The burn address can be replaced with a real address if burning is not desired
    address public erc721BurnAddress = 0x0000000000000000000000000000000000000000;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    bytes4 constant private ERC721_RECEIVED = 0x150b7a02;

    event Burn(address indexed from, uint256 indexed tokenId);

    modifier originalCreatorOnly {
        require(msg.sender == originalCreator);
        _;
    }

    constructor(address _erc721ContractAddress, address _erc1155ContractAddress) public {
        erc721ContractAddress = _erc721ContractAddress;
        erc1155ContractAddress = _erc1155ContractAddress;
    }

    /*
     * Burn the incoming ERC-721 token and mint an ERC-1155 token to the sender
     */
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
        if(!active) revert("Inactive");

        // Transfer the ERC-721 token to the burn address
        ERC721 erc721Contract = ERC721(erc721ContractAddress);

        // This will revert if the token wasn't actually transferred over
        // Note: If an unsafe transfer function was used, this is vulnerable to an attacker executing onERC721Received and claiming the ERC-1155 token
        // This shouldn't happen under typical circumstances, though
        erc721Contract.transferFrom(address(this), erc721BurnAddress, _tokenId);


        // Mint the ERC-1155 token to the sender's address
        ICryptoItems erc1155Contract = ICryptoItems(erc1155ContractAddress);

        address[] memory fromAddresses = new address[](1);
        fromAddresses[0] = _from;
        erc1155Contract.mintNonFungibles(erc1155BaseId, fromAddresses);

        // Emit event signifying completion
        emit Burn(_from, _tokenId);

        return ERC721_RECEIVED;
    }

    /*
     * If unsafe transfer was used to send the ERC-721 token, the originalCreator can send it back.
     */
    function transferToken(uint256 _tokenId, address _to) public originalCreatorOnly {
        ERC721 erc721Contract = ERC721(erc721ContractAddress);
        erc721Contract.transferFrom(address(this), _to, _tokenId);
    }

    function acceptAssignment(uint256 _id) external {
        ICryptoItems erc1155Contract = ICryptoItems(erc1155ContractAddress);
        erc1155Contract.acceptAssignment(_id);

        erc1155BaseId = _id;
        originalCreator = msg.sender;
        active = true;
    }

    function assign() external originalCreatorOnly {
        ICryptoItems erc1155Contract = ICryptoItems(erc1155ContractAddress);
        erc1155Contract.assign(erc1155BaseId, originalCreator);

        originalCreator = address(0);
        active = false;
    }
}