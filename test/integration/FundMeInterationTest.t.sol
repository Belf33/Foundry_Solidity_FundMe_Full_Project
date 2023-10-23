// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundCallOnFundMe, WithdrawCallOnFundMe} from "../../script/Interactions.s.sol";


contract FundMeIntegrationTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); // create mocked user(fake one)
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

     function setUp() external {
        DeployFundMe deployedFundMe = new DeployFundMe();
        fundMe = deployedFundMe.run();
        vm.deal(USER, STARTING_BALANCE); //cheatcode to send mocked user fake money
    }

    function testUserCanFundInteractions() public {

        FundCallOnFundMe fundCallFundMe = new FundCallOnFundMe();
        fundCallFundMe.fundCallOnFundMe(address(fundMe));

        WithdrawCallOnFundMe withdrawCallFundMe = new WithdrawCallOnFundMe();
        withdrawCallFundMe.withdrawCallOnFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);

    }

    // function testUserCanWithdrawInteractions() public {
    //     FundCallFundMe fundCallFundMe = new FundCallFundMe();
    //     fundCallFundMe.fundCallOnFundMe(payable(address(fundMe)));

    //     address founder = fundMe.getFounder(0);
    //     assertEq(founder,  USER);
    // }
}
