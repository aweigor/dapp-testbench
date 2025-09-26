// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Messenger {
  uint public changeCounter;

  address public owner;

  string public theMessage;

  constructor() {
      owner = msg.sender;
  }

  function updateTheMessage(string memory _newMessage) public {
      if(msg.sender == owner) {
          theMessage = _newMessage;
          changeCounter++;
      }
  }
}
