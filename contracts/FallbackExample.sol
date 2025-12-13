// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FallbackExample {
    uint256 public  result;
    //不需要添加function 因为solidity知道receive是一个特殊函数
    //只要我们发送ETH或向这个合约发送交易，只要没有与该交易相关的数据，这个receive函数就会被触发
    receive() external payable { 
        result = 1;
    }

    fallback() external payable { 
        result = 2;
    }
}