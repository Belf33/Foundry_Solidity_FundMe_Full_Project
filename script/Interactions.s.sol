// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundCallOnFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundCallOnFundMe(address _address) public {
        vm.startBroadcast();
        FundMe(payable(_address)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Successfuly Funded to FundMe %s ether", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundCallOnFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawCallOnFundMe is Script {

    function withdrawCallOnFundMe(address _address) public {
        vm.startBroadcast();
        FundMe(payable(_address)).withdraw();
        vm.stopBroadcast();
        console.log("Successfuly Withdraw to FundMe");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawCallOnFundMe(mostRecentlyDeployed);
    }
}
