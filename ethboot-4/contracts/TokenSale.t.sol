// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {TokenSale} from "./TokenSale.sol";

contract TokenSaleUser {
  TokenSale tokenSale;
  constructor(TokenSale tokenSale_) {
    tokenSale = tokenSale_;
  }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  receive() external payable {}
}

contract TokenSaleTest is Test {
  TokenSale tokenSale;
  address payable user1;
  address payable user2;
  address payable self;

  function setUp() public {
    tokenSale = createContract();
    user1 = payable(address(new TokenSale()));
    user2 = payable(address(new TokenSale()));
    self = payable(address(this));
  }

  function createContract() internal returns (TokenSale) {
    return new TokenSale();
  }

}