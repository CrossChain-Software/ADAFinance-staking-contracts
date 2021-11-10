// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../utils/ERC20.sol";
import "../utils/Ownable.sol";

 contract ADAFI is ERC20, Ownable {

    constructor(uint256 _supply) ERC20("ADA", "ADAFI") {
        _mint(msg.sender, _supply * (10 ** decimals()));
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function _transferOwnership(address _newOwner) public onlyOwner { 
        transferOwnership(_newOwner);
    }

 }