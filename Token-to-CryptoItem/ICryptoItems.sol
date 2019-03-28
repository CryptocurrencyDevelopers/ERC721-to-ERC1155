pragma solidity 0.5.4;

/**
    CryptoItems minimized interface
*/
interface ICryptoItems {
    function mintNonFungibles(uint256 _id, address[] _to) external;
    function assign(uint256 _id, address _creator) external;
    function acceptAssignment(uint256 _id) external;
}
