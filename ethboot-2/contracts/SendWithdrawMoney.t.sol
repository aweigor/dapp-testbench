// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SendWithdrawMoney} from "./SendWithdrawMoney.sol";

contract SendWithdrawMoneyUser {
  SendWithdrawMoney sendWithdrawMoney;

  constructor(SendWithdrawMoney sendWithdrawMoney_) public {
    sendWithdrawMoney = sendWithdrawMoney_;
  }

  function getUserBalance() public view returns(uint) {
    return address(this).balance;
  }

  function withdrawAll() public {
    sendWithdrawMoney.withdrawAll();
  }
}

contract SendWithdrawMoneyTest is Test {
  SendWithdrawMoney sendWithdrawMoney;
  address user1;
  address user2;
  address payable self;

  function setUp() public {
    sendWithdrawMoney = createContract();
    user1 = address(new SendWithdrawMoneyUser(sendWithdrawMoney));
    user2 = address(new SendWithdrawMoneyUser(sendWithdrawMoney));
    self = payable(address(this));
  }

  function createContract() internal returns (SendWithdrawMoney) {
    return new SendWithdrawMoney();
  }

  function test_InitialValue() public view {
    require(sendWithdrawMoney.balanceReceived() == 0, "Initial value of counter should be 0");
  }

  function test_Deposit() public view {
    sendWithdrawMoney.deposit{value: 1 ether};
    require(sendWithdrawMoney.getContractBalance() == 1, "Balace must be equal to deposit value");
  }

  function test_WithdrawAll() public {
    sendWithdrawMoney.deposit{value: 1 ether};
    SendWithdrawMoneyUser(user1).withdrawAll();
    SendWithdrawMoneyUser(user2).withdrawAll();
    require(SendWithdrawMoneyUser(user1).getUserBalance() == 1, "First user wthdraws all value");
    require(SendWithdrawMoneyUser(user2).getUserBalance() == 0, "Sencond user has empty withdrawal value");
  }

  function test_WithdrawToAddress() public {
    sendWithdrawMoney.deposit{value: 1 ether};
    sendWithdrawMoney.withdrawToAddress(self);
    require(self.balance == 1, "Value withdraws to specified address");
  }
}