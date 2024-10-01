// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FactorialContract {

    function calculateFactorial(uint256 n) public pure returns (uint256) {
        if(n == 0 || n == 1){
            return 1;
        }
        uint256 result = 1;
        for(uint256 i = 2; i <= n; i++ ){
            result *= i;
        }
        return result;
    }
}