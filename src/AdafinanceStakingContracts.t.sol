// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./AdafinanceStakingContracts.sol";

contract AdafinanceStakingContractsTest is DSTest {
    AdafinanceStakingContracts contracts;

    function setUp() public {
        contracts = new AdafinanceStakingContracts();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
