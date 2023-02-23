// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        // will be executed immediatly when we call a contract
        owner = msg.sender;

    }

    function fund() public payable {
        // $50
        uint256 minimumUSD = 50 * 10 * 18
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);


    }

    function getVersion public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return priceFeed.version();

    }
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        (,int256 answer,,,)
        uint80 answeredInRound = priceFeed.latestRoundData();
        return uint256(answer);
    }
    // 
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmount = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;

    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
