pragma solidity 0.5.4;

/**
    CryptoItems minimized interface
*/
interface ICryptoItems {
    function mintNonFungibles(uint256 _id, address[] calldata _to) external;
    function assign(uint256 _id, address _creator) external;
    function acceptAssignment(uint256 _id) external;
    function setURI(uint256 _id, string calldata _uri) external;
    function nonFungibleCount(uint256 _id) external view returns (uint256);
    function nonFungibleByIndex(uint256 _id, uint256 _index) external view returns (uint256);
}
