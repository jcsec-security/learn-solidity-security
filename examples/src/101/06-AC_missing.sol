// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
	@dev This contract includes an example of lack of access controls in line 37.
	@custom:deployed-at ETHERSCAN URL
	@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
*/
contract Example6 is Ownable {

    mapping (address depositor => uint256 balance) balance;
    mapping (address depositor => uint256 last_deposit) blockstamp;
	
	constructor() Ownable(msg.sender) {}

    function deposit() external payable {
        balance[msg.sender] += msg.value;
		blockstamp[msg.sender] = block.number;
    }
	

	function withdraw() external {		
		// Checks
		require(block.number - blockstamp[msg.sender] > 10,
			"A cooldown of 10 blocks is required!!"
		);

		// Effects	
		uint256 withdrawn = balance[msg.sender];
		balance[msg.sender] = 0;	

		// Interactions
		(bool success, ) = payable(msg.sender).call{value: withdrawn}("");
		require(success, "Low level call failed");
	}

	
	///@notice This function resets the timestamp of the any user, which should be a privileged action
	function resetTimestamp (address user) public {
		blockstamp[user] = 0;
	}

}