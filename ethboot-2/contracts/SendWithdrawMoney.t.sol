// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SendWithdrawMoney} from "./SendWithdrawMoney.sol";

contract SendWithdrawMoneyUser {
  SendWithdrawMoney sendWithdrawMoney;

  constructor(SendWithdrawMoney sendWithdrawMoney_) {
    sendWithdrawMoney = sendWithdrawMoney_;
  }

  function getUserBalance() public view returns(uint) {
    return address(this).balance;
  }

  function withdrawAll() public {
    sendWithdrawMoney.withdrawAll();
  }

  receive() external payable {}
}

contract SendWithdrawMoneyTest is Test {
  SendWithdrawMoney sendWithdrawMoney;
  address payable user1;
  address payable user2;
  address payable self;

  function setUp() public {
    sendWithdrawMoney = createContract();
    user1 = payable(address(new SendWithdrawMoneyUser(sendWithdrawMoney)));
    user2 = payable(address(new SendWithdrawMoneyUser(sendWithdrawMoney)));
    self = payable(address(this));
  }

  function createContract() internal returns (SendWithdrawMoney) {
    return new SendWithdrawMoney();
  }

  function test_InitialValue() public view {
    require(sendWithdrawMoney.balanceReceived() == 0, "Initial value of counter should be 0");
  }

  function test_Deposit() public {
    sendWithdrawMoney.deposit{value: 1 ether}();
    assertEq(sendWithdrawMoney.balanceReceived(), 1 ether);
  }

  function test_WithdrawAll() public {
    sendWithdrawMoney.deposit{value: 1 ether}();
    SendWithdrawMoney(user1).withdrawAll();
    SendWithdrawMoney(user2).withdrawAll();
    require(SendWithdrawMoneyUser(user1).getUserBalance() == 1 ether, "First user wthdraws all value");
    require(SendWithdrawMoneyUser(user2).getUserBalance() == 0 ether, "Sencond user has empty withdrawal value");
  }

  function test_WithdrawToAddress() public {
    sendWithdrawMoney.deposit{value: 1 ether}();
    sendWithdrawMoney.withdrawToAddress(user1);
    assertEq(SendWithdrawMoneyUser(user1).getUserBalance(), 1 ether);
  }
}