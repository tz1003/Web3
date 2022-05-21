// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract ZombieFactory { // create a contract


    // event: communicate something happened on the blockchain to front-end
    event NewZombie(uint zombieId, string name, uint dna);

    //unsigned integer uint256
    uint dnaDigits = 16;

    //create struct
    struct Zombie {
        string name;
        uint dna;
    }

    // create new zombie
    Zombie pophead27 = Zombie("pophead27",1100);

    //array of structs Zombie
    // fixed array
    unit[2] fixedintarray;
    string[5] stringarray;
    //dynamic array, can keep adding it
    Zombie[] public zombies; //public to create getter method 

    //adding zombie into array's end 
    zombies.push(pophead27);
    // or adding directly 
    zombies.push(Zombie("soha",1200));

    // create private function,adding underscore
    // if public, anyone can call this method
    // _name meaning fucntion parameter varaible (differentiate
    // from global variable)
    function _createZombie(string memory _name, uint _dna) private{
        uint id = zombies.push(Zombie(_name,_dna)) - 1; // giving the array length
        // emitting event 
        emit NewZombie(id, _name, _dna);
        
    }

    //returning values
    string greeting = "hi";
    function sayhello() public returns (string memory){
        return greeting;
    }

    //function modifiers
    // 1. view: only viewing the data but not changing
    function sayhello2() public view returns (string memory){
        return greeting;
    }
    // 2. pure: only depends on input (function parameter)
    function _multiply(uint a, uint b) private pure returns (uint){
        return a*b;
    }


    //build in hash function keccak256:SHA3. maps input into a
    // random 256-bit hexadecimal number
    // secure random-number genertion is difficult,here is insecure
    //6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
    keccak256(abi.encodePacked("aaaab"));
    //b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
    keccak256(abi.encodePacked("aaaac"));

    //typecasting
    // below will throws error due to differnt data type
    uint8 a = 5;
    uint b = 6;
    uint8 c = a*b;
    // to fix it
    uint8 c = a*uint8(b);


    function _generateRandomDna(string memory _str) private view returns (uint){
    
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaDigits;
    }


    // summing above up
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name); // underscore for the function
        _createZombie(_name, randDna);



}
