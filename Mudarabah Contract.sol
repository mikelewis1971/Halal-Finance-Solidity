// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mudarabah {
    address public investor;
    address public entrepreneur;
    uint public investorShare; // e.g., 60 means 60%
    bool public investmentComplete;
    uint public capital;
    uint public profit;

    constructor(address _entrepreneur, uint _investorShare) {
        investor = msg.sender;
        entrepreneur = _entrepreneur;
        investorShare = _investorShare;
    }

    function fundBusiness() external payable {
        require(msg.sender == investor, "Only investor can fund");
        require(capital == 0, "Already funded");
        capital = msg.value;
        payable(entrepreneur).transfer(capital);
    }

    function reportProfit() external payable {
        require(msg.sender == entrepreneur, "Only entrepreneur can report");
        require(!investmentComplete, "Profit already shared");
        profit = msg.value;
        uint investorPortion = (profit * investorShare) / 100;
        uint entrepreneurPortion = profit - investorPortion;

        payable(investor).transfer(investorPortion);
        payable(entrepreneur).transfer(entrepreneurPortion);
        investmentComplete = true;
    }
}
