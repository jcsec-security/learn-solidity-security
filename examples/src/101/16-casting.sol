// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;


///@dev This contract includes an example of an integer saturation when casting.
///	please be aware that although solidity > 0.8.0 checks arith it doesn´t mean
///	that it can´t cause an issue then there is a over/underflow.
///	You can read about integer overflows at https://swcregistry.io/docs/SWC-101
///@dev deployed-at ETHERSCAN URL
///@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
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