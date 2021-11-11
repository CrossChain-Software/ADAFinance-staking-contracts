// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PoolFactory.sol";

contract PoolFactoryTest is DSTest {
    PoolFactory poolFactory;

    function setUp() public {
        poolFactory = new PoolFactory();
    }

    function testFailsIfNotMult2() public view {
        uint result = poolFactory.dappTest(4);
        assertEq(result, 4);
    }
}