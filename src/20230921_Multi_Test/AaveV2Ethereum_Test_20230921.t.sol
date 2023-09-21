// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/ProtocolV2TestBase.sol';
import {AaveV2Ethereum_Test_20230921} from './AaveV2Ethereum_Test_20230921.sol';

/**
 * @dev Test for AaveV2Ethereum_Test_20230921
 * command: make test-contract filter=AaveV2Ethereum_Test_20230921
 */
contract AaveV2Ethereum_Test_20230921_Test is ProtocolV2TestBase {
  AaveV2Ethereum_Test_20230921 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18183021);
    proposal = new AaveV2Ethereum_Test_20230921();
  }

  function testProposalExecution() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preAaveV2Ethereum_Test_20230921',
      AaveV2Ethereum.POOL
    );

    GovV3Helpers.executePayload(vm, address(proposal));

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postAaveV2Ethereum_Test_20230921',
      AaveV2Ethereum.POOL
    );

    diffReports('preAaveV2Ethereum_Test_20230921', 'postAaveV2Ethereum_Test_20230921');
  }
}
