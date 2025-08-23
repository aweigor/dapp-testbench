// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Deplyed at Sepolia at 0x9b170d8D6b84a06F9C96f0c87B8f6db032dd243B

contract GiveMeTheMoney {
  
  // event to emit when a memo is created.
  event NewMemo(
    address indexed from,
    uint256 timestamp,
    string name,
    string message  
  );

  // memo struct
  struct Memo {
    address from;
    uint256 timestamp;
    string name;
    string message; 
  }

  // list of all received memos.
  Memo[] memos;

  // address of contract deployer.
  address payable owner;

  // deploy logic - executes only once
  constructor() {
    owner = payable(msg.sender);
  }

  /**
   * @dev give the money to the owner 
   * @param _name name of giver
   * @param _message message from giver
  */
  function giveTheMoney(string memory _name, string memory _message) public payable {
     require(msg.value > 0, "cannot give nothing (need more than 0 eth)");
     // add memo to the storage
     memos.push(Memo(
      msg.sender,
      block.timestamp,
      _name,
      _message
    ));
    // emit event
    emit NewMemo(
      msg.sender,
      block.timestamp,
      _name,
      _message
    ); 
  }

  /**
   * @dev Withdraw the money stored in contract
  */
  function withdrawTheMoney() public {
    require(owner.send(address(this).balance));
  }

  /**
   * @dev retrieve all stored memos
   */
  function getMemos() public view returns(Memo[] memory) {
    return memos; 
  }
}
