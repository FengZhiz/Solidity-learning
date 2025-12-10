//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


contract SimpleStorage {
//     //2-3 Structure types
//     //boolean,unit,int,address,bytes
//     //如果初始化不赋值则默认为0
//     bool hasFavoriteNumber = false;
//     uint256 favoriteNumber = 5;  //末尾数字可以决定分配的空间：unit8->8bit，default=256
//     string favoriteNumberIntext = "Five";
//     int256 favoriteInt = -5;
//     address myAddress = 0x2b9C3536bdB3b966A7E6f776885FCD60E1A1D1ab;
//     bytes32 favoriteBytes = "cat";//byte:0x…………，"cat"->byte string


    //2-4 function
    // uint256 favoriteNumber;  //看不到favoriteNumber数值
    uint256 favoriteNumber;  

    mapping (string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // uint256[] public favoriteNumberList;
    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        // uint256 testVar = 5;
    }
    //0xd9145CCE52D386f254917e481eB44e9943F39138
    //部署一个合约其实就是发送一个交易

    //view/pure
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function add() public pure returns (uint256){
        return (1 + 1);
    }

    // 结构体、映射和数组在作为参数被添加到不同的函数时，需要给定一个memory/calldata关键词
    //calldata,memory,storage
    function addPerson(string memory _name,uint256 _favoriteNumber) public {
        // 第1种方式添加数组
        // People memory newPerson = People({favoriteNumber:_favoriteNumber,name:_name});
        // people.push(newPerson);

        // 第2种方式添加数组
        people.push(People(_favoriteNumber,_name));
        //添加人的时候也要添加到mapping里面
        nameToFavoriteNumber[_name] = _favoriteNumber;

    }
}