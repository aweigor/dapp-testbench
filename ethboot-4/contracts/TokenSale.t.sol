// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {TokenSale} from "./TokenSale.sol";
import {CoffeeToken} from './CoffeeToken.sol';

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

contract CoffeeTokenAdmin {
  CoffeeToken token;
  constructor(TokenSale tokenSale_) {
    token = new CoffeeToken(address(this), address(this));
  }
  
}

contract TokenSaleTest is Test {
  CoffeeToken token;
  TokenSale tokenSale;
  address payable user1;
  address payable user2;
  address payable self;

  function setUp() public {
    token = new CoffeeToken(address(this), address(this));
    tokenSale = new TokenSale(address(token));
    user1 = payable(address(new TokenSaleUser(tokenSale)));
    user2 = payable(address(new TokenSaleUser(tokenSale)));
    self = payable(address(this));
  }

  
}