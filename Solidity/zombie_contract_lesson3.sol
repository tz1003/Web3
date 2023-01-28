pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  // Start here
  modifier aboveLevel(uint _level, uint _zombieId) {
    require (zombies[_zombieId].level>=_level);
    _;
  } 

  // calldata is somehow similar to memory, but it's only available to external functions.
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  function changeDna(uint _zombieId,uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
}

// gas optimisation: view dont cost gas, dont actually change anything 
// only query on lcoal node, no transactionon blockchain(which involve all every single node)

}
