// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.6; 


/**
	@dev This contract includes an example of an "uncatched" integer underflow in line 25 due to the version of solidity in use.
		please be aware that although solidity > 0.8.0 will check arith operations by default
		unchecked{} and assembly{} blocks DO NOT check the math, therefore making over/underflow exploitable.
		You can read about integer overflows at https://swcregistry.io/docs/SWC-101
	@dev deployed-at ETHERSCAN URL
	@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
*/
contract Example5 {

	// Depositor => balance
    mapping (address => uint256) balance;
	// Depositor => blockstamp_latest_deposit
	mapping (address => uint256) blockstamp;
	

    function deposit() external payable {
        balance[msg.sender] += msg.value;
		blockstamp[msg.sender] = block.number;
    }
	

	function withdraw() external {
		// Check
		require(blockstamp[msg.sender] - block.number > 10, // This is incorrectly ordered, causing an underflow
			"A cooldown of 10 blocks is required!"
		);

		// Effects
		uint256 toWithdraw = balance[msg.sender];
		balance[msg.sender] = 0;

		// Interactions
		(bool success, ) = payable(msg.sender).call{value: toWithdraw}("");
		require(success, "Low level call failed");
	}

}


/*****************************************************************************************************/
/************************************** BasicOverflow ************************************************/
/*****************************************************************************************************/


/**
* @dev Basic example to play around with overflows.
* @dev deployed-at ETHERSCAN URL
*/
contract BasicOverflow {

	uint8 public number = 255;
	

	function increment() public {
		number++;
	}


	function resetToMax() public {
		number = 255;
	}
	
}
