// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SampleWallet} from "./SampleWallet.sol";

contract SampleWalletUser {
  SampleWallet sampleWallet;
  constructor(SampleWallet sampleWallet_) {
    sampleWallet = sampleWallet_;
  }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  receive() external payable {}
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

  function test_DenySendingTest() public {
    vm.prank(self);
    address payable contractAddress = payable(sampleWallet);
    bool success = contractAddress.send(1 ether);
    require(success, "Test failed: cannot send funds!");
    sampleWallet.setAllowance(user1, 1000);
    sampleWallet.denySending(user1);
    vm.prank(user1);
    try sampleWallet.transfer(user2, 100, "") {
      fail();
    } catch {
      assertEq(SampleWalletUser(user2).getBalance(), 0);
    }
  }

  function test_Transfer() public {
    vm.prank(self);
    address payable contractAddress = payable(sampleWallet);
    bool success = contractAddress.send(1 ether);
    require(success, "Test failed: cannot send funds!");
    sampleWallet.setAllowance(user1, 1000);
    vm.prank(user1);
    try sampleWallet.transfer(user2, 100, "") {
      assertEq(SampleWalletUser(user2).getBalance(), 100);
    } catch {
      fail();
    }
  }
}