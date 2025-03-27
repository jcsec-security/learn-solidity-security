pragma solidity 0.8.28;

contract Example16 {
    function castIntToUint(int8 value) public pure returns (uint8) {
        return uint8(value);
    }

    function castBroadToNarrow(uint16 value) public pure returns (uint8) {
        return uint8(value);
    }

    function castBytes(bytes4 value) public pure returns (bytes1, bytes5) {
        return (bytes1(value), bytes5(value));
    }
}