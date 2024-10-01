// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EtherSafe {
    mapping(address => uint) balances;
    address owner;

    modifier onlyOwner() {
        require(msg.sender != owner, "Unauthorized!");
        _;
    }
    // events
    event DepositSuccessful(uint indexed _amount, address indexed _depositor);
    event WithdrawalSuccessful(uint indexed _amount, address indexed _receiver);
    event TransferSuccessful(
        address indexed _sender,
        uint indexed _amount,
        address indexed _receiver
    );

    constructor() {
        owner = msg.sender;
    }

    function sanityCheck(address _user) private pure {
        require(_user != address(0));
    }

    function zeroAmountCheck(uint _value) private pure {
        require(_value > 0, "Zero value detected");
    }

    function getBalance() public view returns (uint) {
        sanityCheck(msg.sender);
        return balances[msg.sender];
    }

    function depositEthers() external payable {
        sanityCheck(msg.sender);
        zeroAmountCheck(msg.value);

        balances[msg.sender] += msg.value;

        emit DepositSuccessful(msg.value, msg.sender);
    }

    function withdrawEthers(uint _amount) external {
        sanityCheck(msg.sender);
        zeroAmountCheck(_amount);
        require(_amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "transfer failed!");

        emit WithdrawalSuccessful(_amount, msg.sender);
    }

    function transferEthers(uint _amount, address _to) external {
        sanityCheck(msg.sender);
        sanityCheck(_to);
        zeroAmountCheck(_amount);
        require(_amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "transfer failed");
        
        emit TransferSuccessful(msg.sender, _amount, _to);
    }
}
