// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FootballManager{
    struct Footballer{
        string name;
        uint8 age;
        uint32 income;
        address account;
    }
    Footballer[] public footballers;
    function addFootballer(string memory _name, uint8 _age, uint32 _income, address _account) public {
        footballers.push(Footballer(_name, _age, _income, _account));
    }
    function sackFootballer(uint index) public{
        delete footballers[index];
    }
}