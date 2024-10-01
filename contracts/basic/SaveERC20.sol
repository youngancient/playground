// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SaveERC20 {
    error ZeroAddressError();
    error ZeroAmountDetected();
    error InSufficientFunds();
    error CantSendToZeroAddress();

    address public owner;
    address public  tokenAddress; //ERC20 token contract
    // mapping
    mapping(address => uint) balances;

    // events
    event DepositSuccessful(uint indexed _amount, address indexed _depositor);
    event WithdrawSuccessful(uint indexed _amount, address indexed _withdrawer);
    event TransferSuccessful(
        uint indexed _amount,
        address indexed _sender,
        address indexed _receiver
    );
    event DepositForUserWithinSuccessful(
        uint indexed _amount,
        address indexed _depositor,
        address indexed _receiver
    );
    event DepositForUserFromWithalSuccessful(
        uint indexed _amount,
        address indexed _depositor,
        address indexed _receiver
    );

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function onlyOwner() private view{
        require(msg.sender == owner, "UnAuthorized!");
    }

    function sanityCheck(address _user) private pure {
        if(_user == address(0)){
            revert ZeroAddressError();
        }
    }

    function zeroAmountCheck(uint _amount) private pure {
        if(_amount <= 0){
            revert ZeroAmountDetected();
        }
    }

    function getMyBalance() public view returns (uint) {
        sanityCheck(msg.sender);
        return balances[msg.sender];
    }

    function getAnyBalance(address _user) public view  returns (uint) {
        onlyOwner();
        sanityCheck(_user);
        return balances[_user];
    }

    function getBalanceInERC20(address _user) private view returns (uint) {
        return IERC20(tokenAddress).balanceOf(_user);
    }

    function getContractBalance() public view  returns (uint) {
        onlyOwner();
        return getBalanceInERC20(address(this));
    }

    function deposit(uint _amount) public {
        sanityCheck(msg.sender);
        zeroAmountCheck(_amount);
        require(
            _amount <= getBalanceInERC20(msg.sender),
            "Insuficient funds in ERC20 token!"
        );

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        balances[msg.sender] = balances[msg.sender] + _amount;

        emit DepositSuccessful(_amount, msg.sender);
    }

    function withdraw(uint _amount) public {
        sanityCheck(msg.sender);
        zeroAmountCheck(_amount);
        require(_amount <= getMyBalance(), "Insufficient Balance");

        balances[msg.sender] = balances[msg.sender] - _amount;

        IERC20(tokenAddress).transfer(msg.sender, _amount);

        emit WithdrawSuccessful(_amount, msg.sender);
    }

    function transferFunds(uint _amount, address _to) public {
        sanityCheck(msg.sender);
        sanityCheck(_to);
        zeroAmountCheck(_amount);

        require(
            _amount <= getMyBalance(),
            "Transfer failed! Insufficient Balance"
        );

        balances[msg.sender] = balances[msg.sender] - _amount;

        IERC20(tokenAddress).transfer(_to, _amount);

        emit TransferSuccessful(_amount, msg.sender, _to);
    }

    // this function makes a user from within deposit for another user within
    function depositForAnotherUserWithin(uint _amount, address _to) public {
        sanityCheck(msg.sender);
        sanityCheck(_to);
        zeroAmountCheck(_amount);

        if(_amount > getMyBalance()){
            revert InSufficientFunds();
        }

        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = balances[_to] + _amount;

        emit DepositForUserWithinSuccessful(_amount, msg.sender, _to);
    }

    /*
    this function makes a person (with ERC20token but not within this contract)
     deposit for another user within the contract
    */
    function depositForAnotherUserFromWithal(uint _amount, address _to) public {
        sanityCheck(msg.sender);
        sanityCheck(_to);
        zeroAmountCheck(_amount);

        uint personERC20Balance = getBalanceInERC20(msg.sender);

        if(personERC20Balance < _amount){
            revert InSufficientFunds();
        }

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        balances[_to] = balances[_to] + _amount;

        emit DepositForUserFromWithalSuccessful(_amount, msg.sender, _to);
    }
}
