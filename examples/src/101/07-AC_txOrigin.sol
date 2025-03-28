// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;


/**
	@dev This contract includes an example of bad AC relying on ts.origin, which opens
		a windows for phishing attack against the owner to bypass the AC.
		You can read about access controls through tx.origin at https://swcregistry.io/docs/SWC-115 
	@custom:deployed-at ETHERSCAN URL
	@custom:PracticeAt https://github.com/jcsec-security/learn-solidity-security
	*/
contract Example7 {

    mapping (address depositor => uint256 balance) balance;
    mapping (address depositor => uint256 latest_deposit) blockstamp;
	address public owner;


	///@notice This modifier does not apply AC to the actual caller but to the origin of the transaction
	modifier onlyOwner() {
		require(tx.origin == owner, "Only owner can call this function.");
		_;
	}


	constructor() {
		owner = msg.sender;
	}
	

    function deposit() external payable {
        balance[msg.sender] += msg.value;
		blockstamp[msg.sender] = block.number;
    }
	

	function withdraw() external {		
		// Checks
		require(block.number - blockstamp[msg.sender] > 10,
			"A cooldown of 10 blocks is required!!");

		// Effects	
		uint256 withdrawn = balance[msg.sender];
		balance[msg.sender] = 0;	

		// Interactions
		(bool success, ) = payable(msg.sender).call{value: withdrawn}("");
		require(success, "Low level call failed");
	}

	
	function resetTimestamp (address user) public onlyOwner {
		blockstamp[user] = 0;
	}

}