// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    // Mappings
    mapping ( address => uint256 ) public balances;
    mapping ( address => uint256 ) public depositTimestamps;

    // Variables
    uint256 public constant threshold = 1 ether;
    uint256 public withdrawalDeadline = block.timestamp + 120 seconds;
    uint256 public claimDeadline = block.timestamp + 240 seconds;
    uint256 public currentBlock = 0;
    uint256 public rewardRatePerBlock = 1;

    // Events
    event Stake(address indexed sender, uint256 amount);
    event Received(address, uint);
    event Execute(address indexed sender, uint256 amount);

    modifier withdrawalDeadlineReached(bool requireReached) {
        uint256 timeRemaining = withdrawalTimeLeft();
        if (requireReached) {
            require(timeRemaining == 0, "Withdrawal period is not reached yet.");
        } else {
            require(timeRemaining > 0, "Withdrawal period has been reached.");
        }
        _;
    }

    modifier claimDeadlineReached(bool requireReached) {
        uint256 timeRemaining = withdrawalTimeLeft();
        if (requireReached) {
            require(timeRemaining == 0, "Withdrawal period is not reached yet.");
        } else {
            require(timeRemaining > 0, "Withdrawal period has been reached.");
        }
        _;
    }

    modifier notCompleted(bool requireReached) {
        bool completed = exampleExternalContract.completed();
        require(!completed, "Stake already completed.");
        _;
    }

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    function withdrawalTimeLeft() public view returns (uint256 withdrawalTimeLeftResult) {
        if (block.timestamp >= withdrawalDeadline) {
            return (0);
        } else {
            return (withdrawalDeadline - block.timestamp);
        }
    }

    function claimPeriodLeft() public view returns (uint256 claimPeriodLeftResult) {
        if (block.timestamp >= claimDeadline) {
            return (0);
        } else {
            return (claimDeadline - block.timestamp);
        }
    }

     
    
    function stake() public payable withdrawalDeadlineReached(false) claimDeadlineReached(false) {
        // Collect funds in a payable `stake()` function
        balances[msg.sender] = balances[msg.sender] + msg.value;
        // and track individual `balances` with a mapping:
        depositTimestamps[msg.sender] = block.timestamp;
        // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
        emit Stake(msg.sender, msg.value);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
    function execute() public payable withdrawalDeadlineReached(true) {
        // Collect funds in a payable `stake()` function
        balances[msg.sender] = balances[msg.sender] + msg.value;
        // and track individual `balances` with a mapping:
        depositTimestamps[msg.sender] = block.timestamp;
        // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
        emit Stake(msg.sender, msg.value);
    }

    /*
    Withdraw function
    If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
    */
    function withdraw() public withdrawalDeadlineReached(true) claimDeadlineReached(false) notCompleted(false) {
        require (balances[msg.sender] > 0, "You have no balance to withdraw!");
        uint256 individualBalance = balances[msg.sender];
        uint256 indBalanceRewards = individualBalance + ((block.timestamp - depositTimestamps[msg.sender]) * rewardRatePerBlock);
        balances[msg.sender] = 0;
        //Transfer all ETH via call! (not transfer) cc: https://solidity-by-example.org/sendir
        (bool sent, bytes memory data) = msg.sender.call{value: indBalanceRewards}("");
        require(sent, "RIP; withdrawal failed!");
    }

    
    // Add the `receive()` special function that receives eth and calls stake()
    receive() external payable {

        emit Stake(msg.sender, msg.value);
        emit Received(msg.sender, msg.value);
    }
}
