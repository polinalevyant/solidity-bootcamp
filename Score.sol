// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Score {
    
    uint score;
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        if (msg.sender == owner) {
            _;
        }
    }
    
    function getScore() public view returns (uint) {
        return score;
    }
    
    function setScore(uint new_score) public onlyOwner {
        score = new_score;
    }
}