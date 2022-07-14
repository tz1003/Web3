// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.6.0;

//import "./someothercontract.sol";



contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mapping key-value store type
    // mapping ( key => value)
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;


    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // msg.sender: global variables, refer to ADDRESS(!) of person/smart contract 
        // who called the current function
        // contract will do nothing until some calls one of its functions
        // so there will always be a msg.sender
    
        //edxample for msg.sender/////////////////////////

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
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // restrictions
        require(ownerZombieCount[msg.sender] == 0); // equivalent to asset
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

// inheritance: making subclass, call public function from parent
///////////////example////////////////////////
contract Doge {
  function catchphrase() public returns (string memory) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string memory) {
    return "Such Moon BabyDoge";
  }
}
////////////////////////////////////////////////////

// struct aand array need to define memory/storage
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    // Sandwich mySandwich = sandwiches[_index];

    // ^ Seems pretty straightforward, but solidity will give you a warning
    // telling you that you should explicitly declare `storage` or `memory` here.

    // So instead, you should declare with the `storage` keyword, like:
    Sandwich storage mySandwich = sandwiches[_index];
    // ...in which case `mySandwich` is a POINTER to `sandwiches[_index]`
    // in storage, and...
    mySandwich.status = "Eaten!";
    // ...this will permanently change `sandwiches[_index]` on the blockchain.

    // If you just want a copy, you can use `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...in which case `anotherSandwich` will simply be a COPY of the 
    // data in memory, and...
    anotherSandwich.status = "Eaten!";
    // ...will just modify the temporary variable and have no effect 
    // on `sandwiches[_index + 1]`. But you can do this:
    sandwiches[_index + 1] = anotherSandwich;
    // ...if you want to copy the changes back into blockchain storage.
  }
}




// Create KittyInterface: (接口)(communicate with other contract)
// similiar to contract, differences:
// 1. only declare function we want
// 2. no details within the function {}, ends with ;
contract KittyInterface{
function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
);
}

////////use of interface///////////////////
contract MyContract {
  address NumberInterfaceAddress = 0xab38... 
  // declare a interface
  // ^ The address of the FavoriteNumber contract on Ethereum
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
  // Now `numberContract` is pointing to the other contract
  
  function someFunction() public {
    // Now we can call `getNum` from that contract:
    uint num = numberContract.getNum(msg.sender);
    // ...and do something with `num` here
  }
}
//////////////////////////////////////////


contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // Initialize kittyContract here using `ckAddress` from above
  KittyInterface kittyContract = KittyInterface(ckAddress);

  // Start here
   function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
      // verify the owner
      require(msg.sender == zombieToOwner[_zombieId]);
      // declare a local zombie named MZ, pointer to storage, set it equal
      // to the one in zombies array
    Zombie storage myZombie = zombies[_zombieId];
    // new dna = the mean of parents
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
   // Add an if statement here, cant pass string to keccak256
   // encode first
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName",newDna);

    }

  // define function here
  // care about the space
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // And modify function call here:
    feedAndMultiply(_zombieId, kittyDna,"kitty");


  }

}

