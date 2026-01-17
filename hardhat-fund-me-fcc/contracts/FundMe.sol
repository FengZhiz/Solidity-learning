// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./PriceConverter.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// constant immutable
// 757471 gas
// 737532 gas
error FundMe__NotOwner();

/**
 * @title A contract for crowd funding
 * @author FengZhi
 * @notice Tish contract is to demo a sample funding contract
 * @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConverter for uint256;

    // uint256 public number;
    uint256 public constant MINIMUM_USD = 50 * 1e18; //最小USD金额为美金计算
    //2446 gas - non-constant
    //374 gas - constant

    address[] private s_funders; //记录每个捐款人
    mapping(address => uint256) private s_addressToAmountFunded; //记录每个地址发送资金的数量
    address private immutable i_owner;
    AggregatorV3Interface public s_priceFeed;

    modifier onlyOwner() {
        // require(msg.sender == i_owner,"Sender id not owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    //What happens if someone sends this contract ETH without calling the fund function?
    //receive()   fallback()
    // receive() external payable {
    //     fund();
    // }

    // fallback() external payable {
    //     fund();
    // }

    function fund() public payable {
        // want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        // 如果要求至少发送 1 ether ,关键词 require 会检查 msg.value 是否大于 1
        // require(msg.value > 1e18 , "Didn't send enough!"); //1e18 == 1*10**18 == 1000000000000000000 wei == 1 ether，value单位为ETH
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough ETH!"
        ); //如何将ether转换为usd?这就是oracles的作用

        //msg.value：18 decimals
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = msg.value;

        // What is reverting?
        // undo any action before, and send remaining gas back
        // number = 5;
        // 如果fund函数运行成功，那么number = 5，运行失败则整个函数回滚，number = 0, 消耗的gas也会原路返回
    }

    function withdraw() public onlyOwner {
        //for loop
        /* starting index, ending index, step amount */
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        //reset the array
        s_funders = new address[](0);
        //actually withdraw the funds

        //1.transfer
        // msg.send = address
        //payable (msg.send) = payable address
        // payable (msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Send failed");
    }

    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        //mapping can't be in memory!

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = i_owner.call{
            value: address(this).balance
        }("");
        require(callSuccess, "Send failed");
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funder)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
