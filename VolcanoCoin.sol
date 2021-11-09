// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VolcanoCoin {
    
    uint total_supply = 10000;
    address owner;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        if (msg.sender == owner) {
            _;
        }
    }
    
    event ScoreUpdated(uint);
    
    function incraseTotalSupply() public onlyOwner {
        total_supply = total_supply + 1000;
        emit ScoreUpdated(total_supply);
    }
    
}