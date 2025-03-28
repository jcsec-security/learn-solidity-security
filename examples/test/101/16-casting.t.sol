// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Example16} from "../../src/101/16-casting.sol";

contract CastingTest is Test {
    Example16 castingContract;

    function setUp() public {
        castingContract = new Example16();
    }

    function test_casting_int_to_uint() public view {
        int8 negative = -1;  // Binary: 11111111
        uint8 notNegative = castingContract.castIntToUint(negative); 
        
        assertEq(notNegative, 255);
        
        console.log("negative   : ", negative);
        console.log("notNegative: ", notNegative);
        console.log("-------------------------------------------------------------");
        console.log("| Casting '-1' from int8 to uint8 results in '255', because |");
        console.log("| '11111111' is interpreted as  '-1' when using int8, and   |");
        console.log("| '11111111' is interpreted as '255' when using uint8       |");
        console.log("-------------------------------------------------------------");
    }

    function test_casting_broad_to_narrow() public view {
        uint16 broad = 3241;  // Binary: 0000110010101001
        uint8 narrow = castingContract.castBroadToNarrow(broad);

        assertEq(narrow, 169);
        
        console.log("broad : ", broad);
        console.log("narrow: ", narrow);
        console.log("-----------------------------------------------------------------");
        console.log("| Casting '3241' from uint16 to uint8 results in '169', because |"); 
        console.log("| '0000110010101001' (16 bits) is truncated to                  |");
        console.log("|         '10101001' ( 8 bits) which is interpreted as '169'    |");
        console.log("-----------------------------------------------------------------");
    }

    function test_casting_bytes() public view {
        bytes4 value = 0x83694287; 
        (bytes1 smallValue, bytes5 largeValue) = castingContract.castBytes(value);
        
        assertEq(abi.encodePacked(smallValue), abi.encodePacked(bytes1(0x83)));
        assertEq(abi.encodePacked(largeValue), abi.encodePacked(bytes5(0x8369428700)));
        
        console.log("value      : ");
        console.logBytes4(value);
        console.log("smallValue : ");
        console.logBytes1(smallValue);
        console.log("largeValue : ");
        console.logBytes5(largeValue);
        console.log("-----------------------------------------------------------------------");
        console.log("| When converting from a larger integer type to a smaller one,        |");
        console.log("| the bits on the rigth are kept while the bits on the left are lost. |");
        console.log("| Whereas in converting bytes types, the opposite occurs.             |");
        console.log("-----------------------------------------------------------------------");
    }
}