// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./SimpleStorage.sol";

// ExtraStorage 继承了 SimpleStorage 的全部功能
contract ExtraStorage is SimpleStorage{
    //we hope favoriteNumber + 5
    // override
    // virtual override
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}