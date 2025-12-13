//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; //直接导入

library PriceConverter {
    // 所有库中的函数都必须是internal，让库中的不同函数都可以被uint256调用

        function getPrice() internal view returns(uint256) {
        // conver msg.value to USD
        // need two thing: ABI Address（0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43）
        // AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43).version();
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //price:BTC in terms of USD
        // 9033.148958846, remenber: priceFeed 返回的值中有八个是在小数点之后的(from function decimal:AggregatorV3Interface.sol)
        return uint256(price * 1e10); // 1e10 == 1**10 == 10000000000
    }

    function getVersion() internal  view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}