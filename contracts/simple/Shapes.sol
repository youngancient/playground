// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AreaOfShapes{
    // using  SafeMath for uint256;
    uint public area;
    function areaOfRectangle(uint length, uint breadth) public{
        area = 2 *(length + breadth);
    }
    function areaOfSquare(uint length) public{
        area = length * length;
    }
    function areaOfTriangle(uint base, uint height) public{
        area = (base * height) / 2;
    }
}