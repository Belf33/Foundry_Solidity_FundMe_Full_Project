// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    //implementing library
    using PriceConverter for uint256;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed;
    address[] private s_funders;
    mapping(address => uint) private s_addressToAmountFunded;

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enougth eth"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] =
            s_addressToAmountFunded[msg.sender] +
            msg.value;
    }

    modifier isOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function withdraw() public isOwner {
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool isSuccess, ) = msg.sender.call{value: address(this).balance}("");
        require(isSuccess, "Transaction reverted");
    }

    function getFounder(uint256 _index) external view returns (address) {
        return s_funders[_index];
    }

    function getAggregatorVersion() external view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(
        address _address
    ) external view returns (uint256) {
        return s_addressToAmountFunded[_address];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
