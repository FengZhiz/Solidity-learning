// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./PriceConverter.sol"; //直接导入

// constant immutable
// 757471 gas
// 737532 gas
error NotOwner();
contract FundMe {
    using PriceConverter for uint256;

    // uint256 public number;
    uint256 public constant MINIMUM_USD = 50 * 1e18; //最小USD金额为美金计算
    //2446 gas - non-constant
    //374 gas - constant

    address[] public  funders; //记录每个捐款人
    mapping (address => uint256) public addressToAmountFunded;    //记录每个地址发送资金的数量

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        // 如果要求至少发送 1 ether ,关键词 require 会检查 msg.value 是否大于 1
        // require(msg.value > 1e18 , "Didn't send enough!"); //1e18 == 1*10**18 == 1000000000000000000 wei == 1 ether，value单位为ETH
        require(msg.value.getConversionRate() >= MINIMUM_USD , "Didn't send enough!"); //如何将ether转换为usd?这就是oracles的作用

        //msg.value：18 decimals
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

        // What is reverting?
        // undo any action before, and send remaining gas back
        // number = 5;
        // 如果fund函数运行成功，那么number = 5，运行失败则整个函数回滚，number = 0, 消耗的gas也会原路返回
    }


    function withdraw() public onlyOwner{
        //for loop
        /* starting index, ending index, step amount */
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0); 
        //actually withdraw the funds

        //1.transfer
        // msg.send = address
        //payable (msg.send) = payable address
        // payable (msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send failed");

        //call
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Send failed");
    }
    modifier onlyOwner {
        // require(msg.sender == i_owner,"Sender id not owner!");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    //What happens if someone sends this contract ETH without calling the fund function?
    //receive()   fallback()
    receive() external payable {
        fund();
     }

     fallback() external payable {
        fund();
      }
}