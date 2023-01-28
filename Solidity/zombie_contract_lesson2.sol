// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.6.0;

import "./someothercontract.sol";


// inheritance: making subclass, which call public function from parent
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

// most of the time Solidity will handles storage or memory by default

// struct and array need to define memory/storage
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {

    // storage
    // should declare with the `storage` keyword
    Sandwich storage mySandwich = sandwiches[_index]; // create a POINTER to `sandwiches[_index]` in storage
    mySandwich.status = "Eaten!"; //will permanently change `sandwiches[_index]` on the blockchain.

    // memory
    // If you just want a copy, you can use `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1]; // create a COPY of the data in memory
    anotherSandwich.status = "Eaten!";// will just modify the temporary variable and have no effect on `sandwiches[_index + 1]`
    // But you can copy the changes back into blockchain storage.
  }

}


// define interface by keyword contract
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

// declare an interface assuming function getNum was declare before
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}

contract MyContract {
  address NumberInterfaceAddress = 0xab38... // ^ The address of the FavoriteNumber contract on Ethereum, therefore pointing to the interface/function
  // use an interface, by assigning a pointer to the interface, by using it as declare the datatype 
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
  // Now `numberContract` is pointing to the other contract
  
  function someFunction() public {
    // Now we can call `getNum` from that contract:
    uint num = numberContract.getNum(msg.sender);
    // ...and do something with `num` here
  }
}
//////////another example for using interface/////////////////

contract ZombieFeeding is ZombieFactory {

  // make the cryptoKitties contract address changable
  // 1. Remove this hard-coded address
  // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // 2. Change this to just a declaration:
  // Initialize kittyContract here using `ckAddress` from above
  // KittyInterface kittyContract = KittyInterface(ckAddress);
  KittyInterface kittyContract;
  // 3. Add setKittyContractAddress method here
  // external, anyone can call it
  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }

  // Start here
   function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal {
      // verify the owner
      require(msg.sender == zombieToOwner[_zombieId]);

      // check if myzombie is ready
    require(_isReady(myZombie));
      // declare a local zombie named MZ, pointer to storage, set it equal
      // to the one in zombies array
    Zombie storage myZombie = zombies[_zombieId];
    // new dna = the mean of parents
    _targetDna = _targetDna % dnaModulus; // dont need to declare datatype again
    uint newDna = (myZombie.dna + _targetDna) / 2; // use . to call properties in struct
   // Add an if statement here, cant pass string to keccak256
   // encode first
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName",newDna);

    // triggerCooldown
    _triggerCooldown(myZombie);

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


// multiple return
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // This is how you do multiple assignment:
  (a, b, c) = multipleReturns();
}

// Or if we only cared about one of the values:
function getLastReturnValue() external {
  uint c;
  // We can just leave the other fields blank:
  (,,c) = multipleReturns();
}

// pass reference of a struct directly
  // 1. Define `_triggerCooldown` function here
  // 1. Define `_triggerCooldown` function here
function _triggerCooldown(Zombie storage _zombie) internal {
  _zombie.readyTime = uint32(now+cooldownTime);
}
  // 2. Define `_isReady` function here
  function _isReady(Zombie storage _zombie) internal view returns(bool) {
    return (_zombie.readyTime<=now);
  }


