// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract CreateCbETHProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](2);
    payloads[0] = GovHelpers.buildMainnet(
      0xd91d1331db4F436DaF47Ec9Dd86deCb8EEF946B4
    );
    vm.startBroadcast();
    GovHelpers.createProposal(
      payloads,
      0x05097b8a0818a75c1db7d54dfd0299581cac0218a058017acb4726f7cc49657e
    );
    vm.stopBroadcast();
  }
}
