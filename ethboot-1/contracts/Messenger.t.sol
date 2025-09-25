// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Messenger} from "./Messenger.sol";
import {Test} from "forge-std/Test.sol";

contract CounterTest is Test {
  Messenger messenger;

  function setUp() public {
    messenger = new Messenger();
  }
}
