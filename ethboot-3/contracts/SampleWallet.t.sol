// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SampleWallet} from "./SampleWallet.sol";

contract SampleWalletUser {
  SampleWallet sampleWallet;
  constructor(SampleWallet sampleWallet_) {
    sampleWallet = sampleWallet_;
  }
}

contract SampleWalletTest is Test {
  SampleWallet sampleWallet;
  address payable user1;
  address payable user2;
  address payable self;

  function setUp() public {
    sampleWallet = createContract();
    user1 = payable(address(new SampleWalletUser(sampleWallet)));
    user2 = payable(address(new SampleWalletUser(sampleWallet)));
    self = payable(address(this));
  }

  function createContract() internal returns (SampleWallet) {
    return new SampleWallet();
  }
}