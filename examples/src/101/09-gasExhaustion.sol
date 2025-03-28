// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;


/**
    @dev This contract includes an example of DoS by gas exhaustion (OOG) due to an unbounded loop.
        You can read about Gas Exhaustion at https://swcregistry.io/docs/SWC-128
    @custom:deployed-at ETHERSCAN URL
	@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
    */
contract Example9 {

    address[] creditorAddresses;
    address win;

    function checkCreditors() public {
        for (uint256 i = 1; i < creditorAddresses.length; i++) {
            if (creditorAddresses[i-1] != creditorAddresses[i]) {
               win = creditorAddresses[i];

            }
        }
    }

    function addCreditors() external {
        for(uint256 i=0;i<350;i++) {
            creditorAddresses.push(msg.sender);
        }
    }

    function amIWinner() public view returns (bool) {
       return win == msg.sender;
    }

}

