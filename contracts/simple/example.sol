// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract StudentRecord{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require((msg.sender == owner),"You are not the owner!");
        _;
    }
    function changeOwner (address _newOwner) public onlyOwner{
        owner = _newOwner;
    }
}

contract Calculator{
    uint public x;
    uint public y;
    function compare() public view {
        require(
            x == y, "values are not equal"
        );
    }
}

contract MarketStore{
    uint[] public numbers = [1,2,3,4,5];
    string[] public fruits = ["mango", "apple", "pawpaw"];
    function addFruits(string memory _fruit) public{
        fruits.push(_fruit);
    }
    function numberOfFruits() public view returns(uint){
        return fruits.length;
    }
}



contract Maps{
    mapping (address => uint) public balances;
    function addBalance(address account, uint balance) public {
        balances[account] = balance;
    }
    // errors
    uint public bal;
    // require(bal >= 0,"hehe fraud");
}



contract StringComparisonContract {
 
    function compareStrings(string memory str1, string memory str2) external pure returns (bool) {
       bytes memory str1Bytes = bytes(str1);
       bytes memory str2Bytes = bytes(str2);
       if(str1Bytes.length != str2Bytes.length){
        return false;
       }
        for(uint256 i; i < str1Bytes.length; i ++){
            if(str1Bytes[i] != str2Bytes[i]){
                return false;
            }
        }
        return true;
       
    }
    
}

contract OwnerContract {
    address owner;
    constructor(){
        owner = msg.sender;
    }
    function getOwner() external view returns (address) {
       return owner;
    }
}
contract MaxNumberContract {

    function findMaxNumber(uint256[] memory numbers) external pure returns (uint256) {
       uint256 max;
       for(uint256 i; i < numbers.length; i++){
        if(numbers[i] > max){
            max = numbers[i];
        }
       }
       return max;
    }
} 


contract Safe {
    address owner;
    error NotOwner(address);
    constructor() payable{
        (bool success,) = address(this).call{value : msg.value}("");
        require(success);
        owner = msg.sender;
    }
    function withdraw() public payable{
        if(msg.sender != owner){
            revert NotOwner(msg.sender);
        }
        (bool success,) = owner.call{value : address(this).balance}("");
        require(success);
    }
}