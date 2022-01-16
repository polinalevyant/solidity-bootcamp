// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract VolcanoCoin is ERC20("Volcano Coin", "VLC"), Ownable {
    uint paymentId = 1;
    uint256  constant initialSupply = 100000;
    mapping (address => Payment[]) public payments;
    address admin;

    enum PaymentType { UNKNOWN, BASIC_PAYMENT, REFUND, DIVIDEND, GROUP_PAYMENT }

    struct Payment{
        uint id;
        uint amount;
        address recipient;
        PaymentType paymentType;
        uint timestamp;
        string comment;
    }

    event supplyChanged(uint256);


    constructor() {
        _mint(msg.sender, initialSupply);
        admin = msg.sender;
    }

    function transfer(address _recipient, uint _amount) public virtual override returns (bool) {
        _transfer(msg.sender, _recipient, _amount);
        addPaymentRecord(msg.sender, _recipient, _amount);
        paymentId++;
        return true;
    }

    function addPaymentRecord(address _sender, address _recipient, uint _amount) internal {
        payments[_sender].push(Payment(paymentId, _amount, _recipient, PaymentType.UNKNOWN, block.timestamp, ""));
    }

    function addToTotalSupply(uint256 _quantity) public onlyOwner {
        _mint(msg.sender,_quantity);
        emit supplyChanged(_quantity);
    }

    function getPayments(address _user) public view returns (Payment[] memory) {
        return payments[_user];
    }

    function updatePaymentInfo(uint _paymentId, uint8 _paymentType, string calldata _comment) public {
        require(payments[msg.sender].length > 0, "There are no existing payments.");
        require(_paymentType <= uint8(PaymentType.GROUP_PAYMENT), "Payment type not found.");
        updatePaymentHelper(_paymentId, _paymentType, _comment, msg.sender);
    }

    function updatePaymentType(uint _paymentId, uint8 _paymentType, address _user) public onlyOwner{
        require(payments[_user].length > 0, "There are no existing payments for this user.");
        require(_paymentType <= uint8(PaymentType.GROUP_PAYMENT), "Payment type not found.");
        string memory addressString = toString(msg.sender);
        string memory _comment = string(abi.encodePacked(" - updated by: ", addressString));
        updatePaymentHelper(_paymentId, _paymentType, _comment, _user);
    }

    function updatePaymentHelper(uint _paymentId, uint8 _paymentType, string memory _comment, address _user) internal {
        for(uint i = 0; i < payments[_user].length; i++) {
            if(payments[_user][i].id == _paymentId) {
                payments[_user][i].paymentType = PaymentType(_paymentType);
                payments[_user][i].comment = _comment;
            }
        }
    }

    function toString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }   
        return string(s);
    }       

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}