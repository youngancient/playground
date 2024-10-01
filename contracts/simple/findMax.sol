// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract MaxNumberContract {
    function findMaxNumber(
        uint256[] memory numbers
    ) external pure returns (uint256) {
        uint256 max;
        for (uint256 i; i < numbers.length; i++) {
            if (numbers[i] > max) {
                max = numbers[i];
            }
        }
        return max;
    }
}
