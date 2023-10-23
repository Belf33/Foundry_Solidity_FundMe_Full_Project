// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); // create mocked user(fake one)
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant GAS_PRICE = 1;

    //modifier to make less repeated code in tests!
    modifier funded() {
        //the next TX will be sent by that user
        //Also we can use vm.startPrank() and vm.endPrank()
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        //cheatcode to send mocked user fake money
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() public {
        console.log("Price Feed Version: %s", fundMe.getAggregatorVersion());
        assertEq(fundMe.getAggregatorVersion(), 4);
    }

    function testFundFailsWhenSendZero() public {
        vm.expectRevert(); //cheatcode! next line should revert
        //assert(this tx fail/revert)
        fundMe.fund();
    }

    function testFundFailsWhenNotEnoughEth() public {
        vm.expectRevert(); //cheatcode! next line should revert
        fundMe.fund{value: 5}();
    }

    function testFundUpdatesAddressToAmountFundedDataStructure() public funded {
        uint256 actualAmountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(actualAmountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address actualAddress = fundMe.getFounder(0);
        assertEq(actualAddress, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 ownerStartingBalance = fundMe.getOwner().balance;
        uint256 contractStartingBalance = address(fundMe).balance;

        //Act

        // in comments example how to count gas inside tests
        // uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        //Assert
        uint256 ownerEndingBalance = fundMe.getOwner().balance;
        uint256 contractEndingBalance = address(fundMe).balance;
        assertEq(contractEndingBalance, 0);
        assertEq(
            ownerEndingBalance,
            contractStartingBalance + ownerStartingBalance
        );
    }

    function testWithdrawWithMultipleFunder() public funded {
        //Arrange
        uint160 numberOfFunders = 10; //!! from solidity 0.8 we use uint160 for addresses
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); // cheetcode: prank user and deal money in 1 atomic action
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerStartingBalance = fundMe.getOwner().balance;
        uint256 contractStartingBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            fundMe.getOwner().balance,
            contractStartingBalance + ownerStartingBalance
        );
    }
}
