// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "./PoolFactory.sol";

contract PoolFactoryTest is DSTest {
    PoolFactory poolFactory;

    function setUp() public {
        poolFactory = new PoolFactory();
    }

    function testFailsIfNotMult2() public {
        uint result = poolFactory.dappTest(4);
        uint testGas = result * 2;
        assertEq(testGas, 8);
    }
}