//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage {
    uint256 favoriteNumber;

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // uint256[] public favoriteNumberList;
    People[] public people;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        // uint256 testVar = 5;
    }

    //view/pure
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function add() public pure returns (uint256) {
        return (1 + 1);
    }

    // 结构体、映射和数组在作为参数被添加到不同的函数时，需要给定一个memory/calldata关键词
    //calldata,memory,storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // 第1种方式添加数组
        // People memory newPerson = People({favoriteNumber:_favoriteNumber,name:_name});
        // people.push(newPerson);

        // 第2种方式添加数组
        people.push(People(_favoriteNumber, _name));
        //添加人的时候也要添加到mapping里面
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
