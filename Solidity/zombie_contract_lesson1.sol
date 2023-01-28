// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./ownable.sol"; // Ownable contract takes from OpenZepplin Sol library

contract ZombieFactory is ownable { // create a contract, inherit the ownable
// inherit the functions/eents/modifiers


    // event: communicate something happened on the blockchain to front-end
    // app front-end listen for the event
    event NewZombie(uint zombieId, string name, uint dna);

    //unsigned integer uint256
    // int with signed integer
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    //create struct, complex data type, euqivalent to int, string,etc.
    struct Zombie {
        string name;
        uint dna;
    }

    // create new zombie
    Zombie pophead27 = Zombie("pophead27",1100);

    //array of structs Zombie
    //format:
    //datatype[number if length] public/private name;
    // fixed array
    uint[2] fixedintarray;
    string[5] stringarray;
    //dynamic array, can keep adding it
    Zombie[] public zombies; //public to create getter method 
    // can read but not write

    //adding zombie into array's end 
    zombies.push(pophead27);
    // or adding directly 
    zombies.push(Zombie("soha",1200));

    // mapping key-value store type
    // mapping ( key => value)
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;



    // create private function,adding underscore
    // if public, anyone can call this method
    // interenal: private but could be called by child
    // external: only called outside the contract, other function inside the contract cannot find
    // _name meaning fucntion parameter varaible (differentiate from global variable e.g. _value in function not value=x)
    // memory instruct _name stored in memory 
    // disappear when the function ends
    // required for all reference types such as str, arrays, structs,mappings
    
    // 2 ways to pass argument to Sol function:
    // By value: Sol compiler creates new copy and pass into function, not changing the origin
    // By ref: change it will change the origin
    // ALWAYS PUT UNDERSCORE(_) TO START A PRIVATE FUNCTION
    function _createZombie(string memory _name, uint _dna) internal {
        // two steps
        // 1. push/adding into array
        // 2/ return id
        uint id = zombies.push(Zombie(_name, _dna,1,uint32(now+cooldownTime))) - 1; // giving the array length
        // level 1 and start to count cool down time

        // msg.sender: global variables, refer to(from) ADDRESS(!) of person/smart contract 
        // who called the current function
        // contract will do nothing until some calls one of its functions
        // so there will always be a msg.sender   

        /////example for msg.sender/////////////////////////
        mapping (address => uint) favoriteNumber;
        function setMyNumber(uint _myNumber) public {
        // Update our `favoriteNumber` mapping to store `_myNumber` under `msg.sender`
        favoriteNumber[msg.sender] = _myNumber;
        // ^ The syntax for storing data in a mapping is just like with arrays
        }

        function whatIsMyNumber() public view returns (uint) {
        // Retrieve the value stored in the sender's address
        // Will be `0` if the sender hasn't called `setMyNumber` yet
        return favoriteNumber[msg.sender];
        }
        ////////////////////////////////////////////////////

        // update zombieToOwner,mapping to store msg.sender under that id above
        zombieToOwner[id] = msg.sender; // uint to address
        ownerZombieCount[msg.sender]++; // +=1        
        
    
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
    // 2. pure: only depends on input (function parameter,a and b in this case)
    // run the code isolatingly, saying if parameter x was declared before, this will not know value of x
    function _multiply(uint a, uint b) private pure returns (uint){
        return a*b;
    }


    // build in hash function keccak256:SHA3. maps input into a
    // random 256-bit hexadecimal number
    // secure random-number genertion is difficult,here is insecure
    // keccak256 expects a single parameter of type bytes, 
    // need to pack before calling keccak256
    // 6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
    keccak256(abi.encodePacked("aaaab"));
    //b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
    keccak256(abi.encodePacked("aaaac"));

    //typecasting
    // below will throws error due to differnt data type
    uint8 a = 5;
    uint b = 6;
    uint8 c = a*b; //error
    // to fix it
    uint8 c = a*uint8(b);


    function _generateRandomDna(string memory _str) private view returns (uint){
    
        uint rand = uint(keccak256(abi.encodePacked(_str))); // casting here
        return rand % dnaDigits;
    }


    // summing above up
    function createRandomZombie(string memory _name) public {
        // restrictions
        require(ownerZombieCount[msg.sender] == 0); // equivalent to asset
        uint randDna = _generateRandomDna(_name); // underscore for the function
        _createZombie(_name, randDna);


}
}


// declare the event
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public returns (uint) {
  uint result = _x + _y;
  // fire an event to let the app know the function was called:
  emit IntegersAdded(_x, _y, result);
  return result;
}

/*
Ethereum is like a big, slow, but extremely secure computer. 
When you execute a function, every single node on the network 
needs to run that same function to verify its output — 
thousands of nodes verifying every function execution 
is what makes Ethereum decentralized, 
and its data immutable and censorship-resistant.
gas fee to avoid waste of computational power
*/
// in struct, try to use smaller sized datatype
// packed together tp take up less storage
// also try to keep same type together i.e.
// uint c; uint32 a; uint32 b < uint32 a; uint c; uint32 b

// time
// now will return uinx timestamp (uint256)
// (# of seconds from 1/Jan/1970 to latest block)
// unix traditionally 32-bit, but lead to 2038 problem--overflow
// 64-bit for longer but spend more

// more units: seconds, minutes, hours
