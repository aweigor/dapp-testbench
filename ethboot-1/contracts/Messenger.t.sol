// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Messenger} from "./Messenger.sol";
import {Test} from "forge-std/Test.sol";

contract MessengerUser {
  Messenger messenger;

  constructor(Messenger messenger_) public {
    messenger = messenger_;
  }

  function updateTheMessage(string memory _newMessage) public {
    messenger.updateTheMessage(_newMessage);
  }
}

contract CounterTest is Test {
  Messenger messenger;
  address user1;
  address user2;
  address self;

  function setUp() public {
    messenger = createMessenger();
    user1 = address(new MessengerUser(messenger));
    user2 = address(new MessengerUser(messenger));
    self = address(this);
  }

  function createMessenger() internal returns (Messenger) {
    return new Messenger();
  }

  function test_InitialValue() public view {
    require(messenger.changeCounter() == 0, "Initial value of counter should be 0");
  }

  function test_MessageUpdate() public {
    messenger.updateTheMessage("Hello from owner");
    Messenger(user1).updateTheMessage("Hello from user1");
    Messenger(user1).updateTheMessage("Hello from user2");
    require(keccak256(abi.encodePacked(messenger.theMessage())) == keccak256(abi.encodePacked("Hello from owner")), "Only owner may update the message");
  }

  function test_UpdateCounter() public {
    uint8 t = 10;
    for (uint8 i = 0; i < t; i++) {
      messenger.updateTheMessage("Hello from owner");
    }
    require(messenger.changeCounter() == t, "Value after calling updateTheMessage t times should be t");
  }
}