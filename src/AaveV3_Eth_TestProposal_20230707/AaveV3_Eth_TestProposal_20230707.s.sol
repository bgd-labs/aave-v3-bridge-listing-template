// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3_Eth_TestProposal_20230707} from './AaveV3_Eth_TestProposal_20230707.sol';

/**
 * @dev Deploy AaveV3_Eth_TestProposal_20230707
 * command: make deploy-ledger contract=src/AaveV3_Eth_TestProposal_20230707/AaveV3_Eth_TestProposal_20230707.s.sol:DeployEthereum chain=mainnet
 */
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    new AaveV3_Eth_TestProposal_20230707();
  }
}

/**
 * @dev Create Proposal
 * command: make deploy-ledger contract=src/AaveV3_Eth_TestProposal_20230707/AaveV3_Eth_TestProposal_20230707.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(address(0));
    GovHelpers.createProposal(payloads, GovHelpers.ipfsHashFile(vm, 'src/AaveV3_Eth_TestProposal_20230707/undefined.md'));
  }
}