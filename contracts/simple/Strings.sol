// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StringComparisonContract {
    function compareStrings(
        string memory str1,
        string memory str2
    ) external pure returns (bool) {
        bytes32 str1Bytes = keccak256(abi.encodePacked(str1));
        bytes32 str2Bytes = keccak256(abi.encodePacked(str2));
        return str1Bytes == str2Bytes;
    }
}
