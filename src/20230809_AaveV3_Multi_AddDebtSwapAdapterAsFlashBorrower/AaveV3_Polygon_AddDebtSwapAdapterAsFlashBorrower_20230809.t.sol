// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809} from './AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809.sol';

/**
 * @dev Test for AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809
 * command: make test-contract filter=AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809
 */
contract AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809_Test is ProtocolV3TestBase {
  AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 46111118);
    proposal = new AaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809();
  }

  function testProposalExecution() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preAaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809',
      AaveV3Polygon.POOL
    );

    assertFalse(AaveV3Polygon.ACL_MANAGER.isFlashBorrower(proposal.NEW_FLASH_BORROWER()));

    GovHelpers.executePayload(vm, address(proposal), AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);

    assertTrue(AaveV3Polygon.ACL_MANAGER.isFlashBorrower(proposal.NEW_FLASH_BORROWER()));

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postAaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809',
      AaveV3Polygon.POOL
    );

    diffReports(
      'preAaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809',
      'postAaveV3_Polygon_AddDebtSwapAdapterAsFlashBorrower_20230809'
    );
  }
}
