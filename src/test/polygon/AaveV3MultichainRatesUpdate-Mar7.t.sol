// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3PolRatesUpdate} from '../../contracts/polygon/AaveV3PolRatesUpdate-Mar7.sol';
import {AaveV3OptRatesUpdate} from '../../contracts/optimism/AaveV3OptRatesUpdate-Mar7.sol';
import {AaveV3ArbRatesUpdate} from '../../contracts/arbitrum/AaveV3ArbRatesUpdate-Mar7.sol';

contract AaveV3PolRatesUpdateTest is ProtocolV3TestBase, TestWithExecutor {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 40098990);

    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);
  }

  function testNewChanges() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preTestPolRatesUpdateMar7',
      AaveV3Polygon.POOL
    );

    ReserveConfig memory usdtBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.USDT_UNDERLYING
    );

    ReserveConfig memory eursBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.EURS_UNDERLYING
    );

    ReserveConfig memory maiBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.miMATIC_UNDERLYING
    );

    ReserveConfig memory ageurBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.agEUR_UNDERLYING
    );

    ReserveConfig memory wethBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.WETH_UNDERLYING
    );
    ReserveConfig memory ghstBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.GHST_UNDERLYING
    );
    ReserveConfig memory dpiBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3PolygonAssets.DPI_UNDERLYING
    );

    _executePayload(address(new AaveV3PolRatesUpdate()));

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postTestPolRatesUpdateMar7',
      AaveV3Polygon.POOL
    );

    ReserveConfig memory usdtAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.USDT_UNDERLYING
    );

    ReserveConfig memory eursAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.EURS_UNDERLYING
    );

    ReserveConfig memory maiAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.miMATIC_UNDERLYING
    );

    ReserveConfig memory ageurAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.agEUR_UNDERLYING
    );

    ReserveConfig memory wethAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.WETH_UNDERLYING
    );
    ReserveConfig memory ghstAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.GHST_UNDERLYING
    );
    ReserveConfig memory dpiAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3PolygonAssets.DPI_UNDERLYING
    );

    diffReports('preTestPolRatesUpdateMar7', 'postTestPolRatesUpdateMar7');

    address[] memory assetsChanged = new address[](7);
    assetsChanged[0] = AaveV3PolygonAssets.USDT_UNDERLYING;
    assetsChanged[1] = AaveV3PolygonAssets.EURS_UNDERLYING;
    assetsChanged[2] = AaveV3PolygonAssets.miMATIC_UNDERLYING;
    assetsChanged[3] = AaveV3PolygonAssets.agEUR_UNDERLYING;
    assetsChanged[4] = AaveV3PolygonAssets.WETH_UNDERLYING;
    assetsChanged[5] = AaveV3PolygonAssets.GHST_UNDERLYING;
    assetsChanged[6] = AaveV3PolygonAssets.DPI_UNDERLYING;
    _noReservesConfigsChangesApartFrom(allConfigsBefore, allConfigsAfter, assetsChanged);

    // TODO validate
    usdtBefore.interestRateStrategy = usdtAfter.interestRateStrategy;

    // TODO validate
    eursBefore.interestRateStrategy = eursAfter.interestRateStrategy;

    // TODO validate
    maiBefore.interestRateStrategy = maiAfter.interestRateStrategy;
    maiBefore.reserveFactor = 20_00;

    // TODO validate
    ageurBefore.interestRateStrategy = ageurAfter.interestRateStrategy;

    // TODO validate
    wethBefore.interestRateStrategy = wethAfter.interestRateStrategy;
    wethBefore.reserveFactor = 15_00;

    // TODO validate
    ghstBefore.interestRateStrategy = ghstAfter.interestRateStrategy;
    ghstBefore.reserveFactor = 35_00;

    // TODO validate
    dpiBefore.interestRateStrategy = dpiAfter.interestRateStrategy;
    dpiBefore.reserveFactor = 35_00;

    _validateReserveConfig(usdtBefore, allConfigsAfter);
    _validateReserveConfig(eursBefore, allConfigsAfter);
    _validateReserveConfig(maiBefore, allConfigsAfter);
    _validateReserveConfig(ageurBefore, allConfigsAfter);
    _validateReserveConfig(wethBefore, allConfigsAfter);
    _validateReserveConfig(ghstBefore, allConfigsAfter);
    _validateReserveConfig(dpiBefore, allConfigsAfter);
  }
}

contract AaveV3OptRatesUpdateTest is ProtocolV3TestBase, TestWithExecutor {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 79218113);

    _selectPayloadExecutor(AaveGovernanceV2.OPTIMISM_BRIDGE_EXECUTOR);
  }

  function testNewChanges() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preTestOptRatesUpdateMar7',
      AaveV3Optimism.POOL
    );

    ReserveConfig memory usdtBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3OptimismAssets.USDT_UNDERLYING
    );

    ReserveConfig memory wethBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3OptimismAssets.WETH_UNDERLYING
    );

    _executePayload(address(new AaveV3OptRatesUpdate()));

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postTestOptRatesUpdateMar7',
      AaveV3Optimism.POOL
    );

    ReserveConfig memory usdtAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3OptimismAssets.USDT_UNDERLYING
    );

    ReserveConfig memory wethAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3OptimismAssets.WETH_UNDERLYING
    );

    diffReports('preTestOptRatesUpdateMar7', 'postTestOptRatesUpdateMar7');

    address[] memory assetsChanged = new address[](2);
    assetsChanged[0] = AaveV3OptimismAssets.USDT_UNDERLYING;
    assetsChanged[1] = AaveV3OptimismAssets.WETH_UNDERLYING;
    _noReservesConfigsChangesApartFrom(allConfigsBefore, allConfigsAfter, assetsChanged);

    // TODO validate
    usdtBefore.interestRateStrategy = usdtAfter.interestRateStrategy;

    // TODO validate
    wethBefore.interestRateStrategy = wethAfter.interestRateStrategy;
    wethBefore.reserveFactor = 15_00;

    _validateReserveConfig(usdtBefore, allConfigsAfter);
    _validateReserveConfig(wethBefore, allConfigsAfter);
  }
}

contract AaveV3ArbRatesUpdateTest is ProtocolV3TestBase, TestWithExecutor {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 67855095);

    _selectPayloadExecutor(AaveGovernanceV2.ARBITRUM_BRIDGE_EXECUTOR);
  }

  function testNewChanges() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preTestArbRatesUpdateMar7',
      AaveV3Arbitrum.POOL
    );

    ReserveConfig memory usdtBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3ArbitrumAssets.USDT_UNDERLYING
    );

    ReserveConfig memory eursBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3ArbitrumAssets.EURS_UNDERLYING
    );

    ReserveConfig memory wethBefore = _findReserveConfig(
      allConfigsBefore,
      AaveV3ArbitrumAssets.WETH_UNDERLYING
    );

    _executePayload(address(new AaveV3ArbRatesUpdate()));

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postTestArbRatesUpdateMar7',
      AaveV3Arbitrum.POOL
    );

    ReserveConfig memory usdtAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3ArbitrumAssets.USDT_UNDERLYING
    );

    ReserveConfig memory eursAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3ArbitrumAssets.EURS_UNDERLYING
    );

    ReserveConfig memory wethAfter = _findReserveConfig(
      allConfigsAfter,
      AaveV3ArbitrumAssets.WETH_UNDERLYING
    );

    diffReports('preTestArbRatesUpdateMar7', 'postTestArbRatesUpdateMar7');

    address[] memory assetsChanged = new address[](3);
    assetsChanged[0] = AaveV3ArbitrumAssets.USDT_UNDERLYING;
    assetsChanged[1] = AaveV3ArbitrumAssets.EURS_UNDERLYING;
    assetsChanged[2] = AaveV3ArbitrumAssets.WETH_UNDERLYING;
    _noReservesConfigsChangesApartFrom(allConfigsBefore, allConfigsAfter, assetsChanged);

    // TODO validate
    usdtBefore.interestRateStrategy = usdtAfter.interestRateStrategy;

    // TODO validate
    eursBefore.interestRateStrategy = eursAfter.interestRateStrategy;

    // TODO validate
    wethBefore.interestRateStrategy = wethAfter.interestRateStrategy;
    wethBefore.reserveFactor = 15_00;

    _validateReserveConfig(usdtBefore, allConfigsAfter);
    _validateReserveConfig(eursBefore, allConfigsAfter);
    _validateReserveConfig(wethBefore, allConfigsAfter);
  }
}