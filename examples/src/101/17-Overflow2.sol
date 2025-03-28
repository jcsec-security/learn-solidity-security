// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;


/**
	@dev This contract includes an example of an integer underflow in line 25.
		please be aware that although solidity > 0.8.0 checks arith it doesn´t mean
		that it can´t cause an issue then there is a over/underflow.
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
		require(blockstamp[msg.sender] - block.number > 10, // This is incorrectly ordered, causing a revert on underflow
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
