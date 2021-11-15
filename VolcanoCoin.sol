// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VolcanoCoin {
    
    uint total_supply = 10000;
    address owner;

    struct Payment {
        address recipient;
        uint amount;
    }
    
    mapping (address => uint) private balances;
    mapping (address => Payment[]) private payments;
    
    constructor() {
        owner = msg.sender;
        balances[owner] = total_supply;
    }
    
    modifier onlyOwner {
        if (msg.sender == owner) {
            _;
        }
    }
    
    event SupplyIncreased(uint);
    event TransactionSuccess(uint, address);
    
    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }
    
    function getSupply() public view returns (uint) {
        return total_supply;
    }
    
    function incraseTotalSupply() public onlyOwner {
        total_supply += 1000;
        balances[owner] = total_supply;
        emit SupplyIncreased(total_supply);
    }
    
    function transfer(uint _amount, address _recipient) public returns (bool) {
        if (_amount <= balances[msg.sender]) {
            balances[msg.sender] = balances[msg.sender] -= _amount;
            balances[_recipient] = balances[_recipient] += _amount;
            payments[msg.sender].push(Payment({recipient: _recipient, amount: _amount}));
            emit TransactionSuccess(_amount, _recipient);
            return true;
        } else {
            return false;
        }
    }
    
    function getPaymentsCount(address account) public view returns (uint) {
        return payments[account].length;
    }
    
    function getPayments(address account) public view returns (Payment[] memory) {
        return payments[account];
    }
}
