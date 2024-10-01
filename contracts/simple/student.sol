// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract StudentPortal {
    address owner;
    uint16 counter;

    constructor() {
        owner = msg.sender;
    }

    struct Student {
        uint16 id;
        uint8 age;
        string name;
        string email;
        string dob;
        string lga;
        string country;
        string state;
    }
    mapping(uint16 => Student) idToStudentMap;
    Student[] allStudents;

    modifier onlyOwner() {
        require(msg.sender == owner, "UnAuthorized!!");
        _;
    }

    function doesStudentExist(uint16 _id) public view returns (bool) {
        require(_id >= 0, "Invalid id!");
        require(
            idToStudentMap[_id].age > 0,
            "Student with such id does not exist!"
        );
        return true;
    }

    function getAllStudents() external view returns (Student[] memory) {
        return allStudents;
    }

    function GetStudentById(uint16 _id) public view returns (Student memory) {
        bool _doesStudentExist = doesStudentExist(_id);
        require(_doesStudentExist, "Student does not exist!");
        return idToStudentMap[_id];
    }

    function createStudent(
        uint8 _age,
        string memory _name,
        string memory _email,
        string memory _dob,
        string memory _lga,
        string memory _country,
        string memory _state
    ) external onlyOwner {
        Student memory student = Student(
            counter,
            _age,
            _name,
            _email,
            _dob,
            _lga,
            _country,
            _state
        );
        // add to map
        idToStudentMap[counter] = student;
        // add to array
        allStudents.push(student);
        counter = counter + 1;
    }

    function updateStudent(
        uint16 _id,
        uint8 _age,
        string memory _name,
        string memory _dob,
        string memory _lga,
        string memory _country,
        string memory _state
    ) external onlyOwner {
        bool _doesStudentExist = doesStudentExist(_id);
        if (_doesStudentExist) {
            Student storage student = idToStudentMap[_id];
            student.name = _name;
            student.age = _age;
            student.dob = _dob;
            student.lga = _lga;
            student.country = _country;
            student.state = _state;
        }
    }

    function deleteStudent(uint16 _id) external onlyOwner {
        bool _doesStudentExist = doesStudentExist(_id);
        if (_doesStudentExist) {
            delete idToStudentMap[_id];
            delete allStudents[_id];
        }
    }
}
