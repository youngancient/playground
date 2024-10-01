// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Counter {
    uint256 private counter;
    function get() external view returns(uint256){
        return counter;
    }
    function increment() external {
        counter ++;
    }
    function decrement() public {
        counter --;
    }
}
