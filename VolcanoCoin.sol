// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VolcanoCoin is ERC20, Ownable {
    
    constructor() ERC20("VolcanoCoin", "VLC") {
        _mint(msg.sender, 10000);
    }
    
     struct Payment {
        address sender;
        address recipient;
        uint amount;
    }
    
    mapping (address => Payment[]) public payments;
    
    event SupplyIncreased(uint);
    
    function incraseTotalSupply() public onlyOwner {
        _mint(msg.sender, 1000);
        emit SupplyIncreased(totalSupply());
    }
    
    function getPaymentsCount(address account) public view returns (uint) {
        return payments[account].length;
    }
    
    function getPayments(address account) public view returns (Payment[] memory) {
        return payments[account];
    }
    
    function recordPayment(address _sender, address _recipient, uint _amount) private returns (bool) {
        payments[msg.sender].push(
            Payment({
                sender: _sender, 
                recipient: _recipient, 
                amount: _amount}));
        return true;
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        recordPayment(msg.sender, recipient, amount);
        super.transfer(recipient,amount);
        return true;
    }
}
