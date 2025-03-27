// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Murabaha {
    address public buyer;
    address public seller;
    uint public totalPrice;
    uint public monthlyPayment;
    uint public duration;
    uint public paidAmount;
    uint public startTime;

    constructor(
        address _buyer,
        address _seller,
        uint _cost,
        uint _markup, // markup in % (e.g. 10 means 10%)
        uint _durationMonths
    ) {
        buyer = _buyer;
        seller = _seller;
        totalPrice = _cost + (_cost * _markup) / 100;
        duration = _durationMonths;
        monthlyPayment = totalPrice / duration;
        startTime = block.timestamp;
    }

    function payInstallment() external payable {
        require(msg.sender == buyer, "Only buyer can pay");
        require(msg.value == monthlyPayment, "Incorrect payment");
        require(paidAmount < totalPrice, "Paid in full");

        paidAmount += msg.value;
        payable(seller).transfer(msg.value);
    }

    function isPaidOff() external view returns (bool) {
        return paidAmount >= totalPrice;
    }
}
