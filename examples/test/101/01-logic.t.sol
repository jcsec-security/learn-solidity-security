// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import {Example1} from "../../src/101/01-logic.sol";

contract Example1Test is Test {
    Example1 internal example;

    function setUp() public {
        example = new Example1();

        // Vault 0: 1000, 800, 200, 300 => sum = 2300
        example.deposit{value: 1000}(0);
        example.deposit{value: 800}(0);
        example.deposit{value: 200}(0);
        example.deposit{value: 300}(0);

        // Vault 1: 400, 0, 0, 200 => sum = 600
        example.deposit{value: 400}(1);
        example.deposit{value: 0}(1);
        example.deposit{value: 0}(1);
        example.deposit{value: 200}(1);

        // Vault 2: 10, 50, 0, 0 => sum = 60
        example.deposit{value: 10}(2);
        example.deposit{value: 50}(2);
        example.deposit{value: 0}(2);
        example.deposit{value: 0}(2);
    }

    function test_checkCredit_printLockedStates() public {
        example.checkCredit();

        // Exact behavior for the contract as pasted:
        // accumulator after vault 0 = 2300
        // accumulator after vault 1 = 2900
        // accumulator after vault 2 = 2960
        // Since accumulator never drops below 1000, none get locked.
        assertFalse(example.vaultState(0));
        assert(example.vaultState(1));
        assert(example.vaultState(2));
    }
}