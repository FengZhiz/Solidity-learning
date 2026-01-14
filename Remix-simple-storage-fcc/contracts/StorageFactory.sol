// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./SimpleStorage.sol";

contract StorageFactory {
    // SimpleStorage public simpleStorage;
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // how does storage factory know what simple srtorage looks like?
        // simpleStorage = new SimpleStorage();
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    // 存入数据
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //if you wangt to interacte with other contracts, you need two: 
        //1.Address
        //2.ABI : Application Binary Interface

        // SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        // simpleStorage.store(_simpleStorageNumber);
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    // 读取所创建的所有SimpleStorage合约中的数据
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        // SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        // return simpleStorage.retrieve();
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}