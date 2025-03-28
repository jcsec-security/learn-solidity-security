// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;


///@dev This contract includes an example of an storage collision between proxy and imp.
///@dev deployed-at ETHERSCAN URL
///@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
contract Proxy {
    address public implementation;
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    function setImplementation(address _implementation) public {
        require(msg.sender == owner, "Only owner can set implementation");
        implementation = _implementation;
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "delegatecall failed");
    }
}

contract Implementation {
    uint public x;
    address public owner;

    function setX(uint _x) public {
        x = _x;
    }
}