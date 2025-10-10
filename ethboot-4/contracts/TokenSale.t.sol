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
  constructor() {
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

  function test_PurchaseTest() public {
    // Setup: Give user1 some ETH and mint tokens to the test contract
    vm.deal(user1, 5 ether);
    
    // Mint tokens to the test contract (which has MINTER_ROLE)
    token.mint(address(this), 1000 ether);
    
    // Approve TokenSale to spend tokens from test contract
    token.approve(address(tokenSale), 1000 ether);
    
    // Add tokens to the TokenSale contract for sale
    token.transfer(address(tokenSale), 1000 ether);
    
    // Record initial balances
    uint256 initialUser1Eth = user1.balance;
    uint256 initialUser1Tokens = token.balanceOf(user1);
    uint256 initialTokenSaleEth = address(tokenSale).balance;
    uint256 initialTokenSaleTokens = token.balanceOf(address(tokenSale));
    
    // Test purchase with exact amount (1 ether)
    vm.prank(user1);
    tokenSale.purchase{value: 1 ether}();
    
    // Verify balances after purchase
    assertEq(user1.balance, initialUser1Eth - 1 ether, "User1 ETH balance incorrect");
    assertEq(token.balanceOf(user1), initialUser1Tokens + 1 ether, "User1 token balance incorrect");
    assertEq(address(tokenSale).balance, initialTokenSaleEth + 1 ether, "TokenSale ETH balance incorrect");
    assertEq(token.balanceOf(address(tokenSale)), initialTokenSaleTokens - 1 ether, "TokenSale token balance incorrect");
  }

  function test_PurchaseWithExcessFunds() public {
    // Setup: Give user1 some ETH and mint tokens to the test contract
    vm.deal(user1, 5 ether);
    
    // Mint tokens to the test contract
    token.mint(address(this), 1000 ether);
    token.approve(address(tokenSale), 1000 ether);
    token.transfer(address(tokenSale), 1000 ether);
    
    // Record initial balances
    uint256 initialUser1Eth = user1.balance;
    uint256 initialUser1Tokens = token.balanceOf(user1);
    
    // Test purchase with excess amount (2.5 ether should buy 2 tokens, return 0.5 ether)
    vm.prank(user1);
    tokenSale.purchase{value: 2.5 ether}();
    
    // Verify balances after purchase
    assertEq(user1.balance, initialUser1Eth - 2 ether, "User1 ETH balance incorrect (should have 0.5 ether returned)");
    assertEq(token.balanceOf(user1), initialUser1Tokens + 2 ether, "User1 token balance incorrect");
  }

  function test_PurchaseInsufficientFunds() public {
    // Setup: Give user1 some ETH and mint tokens to the test contract
    vm.deal(user1, 0.5 ether); // Less than 1 ether required
    
    // Mint tokens to the test contract
    token.mint(address(this), 1000 ether);
    token.approve(address(tokenSale), 1000 ether);
    token.transfer(address(tokenSale), 1000 ether);
    
    // Test purchase with insufficient funds - should revert
    vm.prank(user1);
    vm.expectRevert("Not enough money sent");
    tokenSale.purchase{value: 0.5 ether}();
  }

  function test_PurchaseMultipleTokens() public {
    // Setup: Give user1 some ETH and mint tokens to the test contract
    vm.deal(user1, 10 ether);
    
    // Mint tokens to the test contract
    token.mint(address(this), 1000 ether);
    token.approve(address(tokenSale), 1000 ether);
    token.transfer(address(tokenSale), 1000 ether);
    
    // Record initial balances
    uint256 initialUser1Eth = user1.balance;
    uint256 initialUser1Tokens = token.balanceOf(user1);
    
    // Test purchase of 3 tokens
    vm.prank(user1);
    tokenSale.purchase{value: 3 ether}();
    
    // Verify balances after purchase
    assertEq(user1.balance, initialUser1Eth - 3 ether, "User1 ETH balance incorrect");
    assertEq(token.balanceOf(user1), initialUser1Tokens + 3 ether, "User1 token balance incorrect");
  }
}