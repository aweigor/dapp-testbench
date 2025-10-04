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

  function test_SetAllowanceSenderRevertTest() public {
    vm.prank(user1);
    vm.expectRevert("You are not the owner, aborting!");
    sampleWallet.setAllowance(user1, 0);
    assertEq(sampleWallet.allowance(user1), 0);
  }

  function test_SetAllowanceAllowanceValueAfterRevertTest() public {
    vm.prank(user1);
    try sampleWallet.setAllowance(user1, 0) {
      fail();
    } catch {
      assertEq(sampleWallet.allowance(user1), 0);
      assertEq(sampleWallet.isAllowedToSend(user1), false);
    }
  }

  function test_SetAllowanceAllowanceValueAfterUpdateTest() public {
    vm.prank(self);
    try sampleWallet.setAllowance(user1, 1) {
      assertEq(sampleWallet.allowance(user1), 1);
      assertEq(sampleWallet.isAllowedToSend(user1), true);
    } catch {
      fail();
    }
  }
}