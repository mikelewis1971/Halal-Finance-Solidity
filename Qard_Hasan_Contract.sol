// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QardHasan {
    address public lender;
    address public borrower;
    uint public loanAmount;
    uint public repaidAmount;
    bool public loanIssued;

    constructor(address _borrower, uint _amount) {
        lender = msg.sender;
        borrower = _borrower;
        loanAmount = _amount;
    }

    function issueLoan() external payable {
        require(msg.sender == lender, "Only lender can issue");
        require(!loanIssued, "Loan already issued");
        require(msg.value == loanAmount, "Incorrect amount");
        loanIssued = true;
        payable(borrower).transfer(loanAmount);
    }

    function repay() external payable {
        require(msg.sender == borrower, "Only borrower can repay");
        require(loanIssued, "Loan not issued");
        require(repaidAmount < loanAmount, "Already repaid");

        repaidAmount += msg.value;
        payable(lender).transfer(msg.value);
    }

    function isFullyRepaid() public view returns (bool) {
        return repaidAmount >= loanAmount;
    }
}

