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
        emit log("ahh im test logginggggggg");
        emit log_uint(testGas);
        assertEq(testGas, 8);
    }

    function testCreateStakingPool() public {
        emit log("ahh im test logginggggggg");
        // baseMod = 100
        uint result = poolFactory.createStakingPool(1000, [1500,2000], 75, 75, 1000, [20, 30], 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);
        assertEq(result);
    }
}