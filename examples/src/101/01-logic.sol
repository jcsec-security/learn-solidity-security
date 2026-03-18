// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/console2.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


uint256 constant N_VAULT = 3;


/**
	@dev This contract includes an examples of a logic bug. Line 33 updates the accumulator only when entering the if statement, instead of updating it at the end of the loop.
	@custom:practice-at https://github.com/jcsec-security/learn-solidity-security
*/
contract Example1 is Ownable {

	struct Vault {
		bool locked;
		uint256[] wallet;
	}

	Vault[N_VAULT] vaults;

	constructor() Ownable(msg.sender) {}

    function checkCredit() external onlyOwner {
		uint256 accumulator = 0;
		for (uint256 i = 0; i < N_VAULT; i++) { 	
			for (uint256 j = 0; j< vaults[i].wallet.length; j++) {
				accumulator += vaults[i].wallet[j];
				console2.log("Vault #", i);
				console2.log("    wallet #", j);
				console2.log("    funds ", vaults[i].wallet[j]);
				console2.log("  acc -->", accumulator);
			}
			
			if (accumulator < 1000) {
				vaults[i].locked = true;
				accumulator = 0; // <--- This line should be outside the if statement
			}		
			console2.log("  Locked?", vaults[i].locked);
			console2.log("");
		}
    }


	function deposit(uint256 n_vault) external payable {
		require(n_vault < N_VAULT, "Vault does not exist");

		vaults[n_vault].wallet.push(msg.value);
	}


	function vaultState(uint256 n_vault) public view returns (bool) {
		return vaults[n_vault].locked;
	}

}
