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

    mapping (address depositor => uint256) balance;
	mapping (address depositor => uint256 n_block) latest_deposit;
	

    function deposit() external payable {
        balance[msg.sender] += msg.value;
		latest_deposit[msg.sender] = block.number;
    }
	

	function withdraw() external {
		// Check
		require(latest_deposit[msg.sender] - block.number > 10, // This is incorrectly ordered, causing a revert on underflow
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
