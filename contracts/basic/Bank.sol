// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank{
    struct Account{
        string name;
        uint balance;
    }
    mapping (address => Account) customers;
    uint256 constant ETHTOWEI = 1000000000000000000;
    // can accept deposits
    receive() external payable { }

    function doesAccountExist() public view returns(bool){
        return bytes(customers[msg.sender].name).length > 0 ;
    }
    function doesAccountExistWithParams(address _address) internal view returns(bool){
        return bytes(customers[_address].name).length > 0 ;
    }
    function createAccount(string memory _name) public{
        bool isCustomer = doesAccountExist();
        require(!isCustomer,"You have an account already!");
        customers[msg.sender] = Account(_name,0);
    }

    function getBalance() public view returns(uint){
        bool isCustomer = doesAccountExist();
        require(isCustomer,"Fraud! You don't have an account,Open one!");
        return (customers[msg.sender].balance / ETHTOWEI);
    }

    function deposit() public payable {
        bool isCustomer = doesAccountExist();
        require(isCustomer,"Fraud! You don't have an account,Open one!");
        require(msg.value > 0,"You cannot send zero !");
        customers[msg.sender].balance += msg.value;
        (bool success,) = address(this).call{value : msg.value}("");
        require(success);
    }
    function withdrawInEth(bool _emptyAccount, uint _amountInEth) public payable {
        bool isCustomer = doesAccountExist();
        require(isCustomer,"Fraud! You don't have an account,Open one!");
        if(_emptyAccount){
            (bool success,) = msg.sender.call{value : customers[msg.sender].balance}("");
            require(success);
        }else{
            require(customers[msg.sender].balance >= (_amountInEth * ETHTOWEI) ,"Insufficient balance");
            customers[msg.sender].balance -= (_amountInEth * ETHTOWEI);
            (bool success,) = msg.sender.call{value : (_amountInEth * ETHTOWEI)}("");
            require(success);
        }
    }
    function transfer(address _recipient, uint256 _amountInEth) public payable {
        bool isCustomer = doesAccountExist();
        require(isCustomer,"Fraud! You don't have an account,Open one!");
        
        bool isRecipientCustomer = doesAccountExistWithParams(_recipient);
        require(isRecipientCustomer,"Recipient does not have an account!");

        require(customers[msg.sender].balance >= (_amountInEth * ETHTOWEI) ,"Insufficient balance");
        customers[msg.sender].balance -= (_amountInEth * ETHTOWEI);
        customers[_recipient].balance += (_amountInEth * ETHTOWEI);

        (bool success,) = _recipient.call{value : (_amountInEth * ETHTOWEI)}("");
            require(success);
    }
}