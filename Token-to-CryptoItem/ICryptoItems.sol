pragma solidity 0.5.4;

/**
    CryptoItems minimized interface
*/
interface ICryptoItems {
    function mintNonFungible(uint256 _id, address _to) external;
}
