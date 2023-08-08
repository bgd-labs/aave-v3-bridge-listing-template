// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/ProtocolV2TestBase.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveV2EthBUSDIR_20230804} from 'src/AaveV2EthBUSDIR_20230804/AaveV2EthBUSDIR_20230804.sol';
import {AaveV2_Eth_TUSDRateUpdate_20230808} from 'src/AaveV2EthBUSDIR_20230804/AaveV2EthTUSDRateUpdate_20230804.sol';
import {IERC20} from 'lib/solidity-utils/src/contracts/oz-common/interfaces/IERC20.sol';

/**
 * @dev Test for AaveV2EthBUSDIR_20230804
 * command: make test-contract filter=AaveV2EthBUSDIR_20230804_Test
 */

contract AaveV2EthBUSDIR_20230804_Test is ProtocolV2TestBase {
  address public constant BUSD = AaveV2EthereumAssets.BUSD_UNDERLYING;
  string public constant BUSD_SYMBOL = 'BUSD';

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 17844191);
  }

  function testBUSD() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'pre-BUSD-Payload-activation_20230804',
      AaveV2Ethereum.POOL
    );

    ReserveConfig memory configBUSDBefore = _findReserveConfigBySymbol(
      allConfigsBefore,
      BUSD_SYMBOL
    );

    address BUSDPayload = address(new AaveV2EthBUSDIR_20230804());
    address TUSDUpdatePayload = address(new AaveV2_Eth_TUSDRateUpdate_20230808());

    uint256 aBUSDBalanceBefore = IERC20(AaveV2EthereumAssets.BUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 BUSDBalanceBefore = IERC20(AaveV2EthereumAssets.BUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );

    GovHelpers.executePayload(vm, BUSDPayload, AaveGovernanceV2.SHORT_EXECUTOR);
    GovHelpers.executePayload(vm, TUSDUpdatePayload, AaveGovernanceV2.SHORT_EXECUTOR);

    // check balances are correct
    uint256 aBUSDBalanceAfter = IERC20(AaveV2EthereumAssets.BUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 BUSDBalanceAfter = IERC20(AaveV2EthereumAssets.BUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    assertApproxEqAbs(aBUSDBalanceAfter, 0, 2000 ether, 'aBUSD_LEFTOVER');
    assertEq(BUSDBalanceAfter, aBUSDBalanceBefore + BUSDBalanceBefore);
    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'post-BUSD-Payload-activation_20230804',
      AaveV2Ethereum.POOL
    );

    // check it's not bricked
    ReserveConfig memory configBUSDAfter = _findReserveConfigBySymbol(allConfigsAfter, BUSD_SYMBOL);
    _withdraw(
      configBUSDAfter,
      AaveV2Ethereum.POOL,
      0xc579a79376148c4B17821C5Eb9434965f3a15C80,
      1 ether
    ); // aBUSD whale

    // e2eTest(AaveV2Ethereum.POOL);

    // e2eTestAsset(
    //   AaveV2Ethereum.POOL,
    //   _findReserveConfig(allConfigsAfter, AaveV2EthereumAssets.TUSD_UNDERLYING),
    //   _findReserveConfig(allConfigsAfter, AaveV2EthereumAssets.BUSD_UNDERLYING)
    // );

    // check there are no unexpected changes
    // _noReservesConfigsChangesApartFrom(
    //   allConfigsBefore,
    //   allConfigsAfter,
    //   configBUSDBefore.underlying
    // );

    diffReports('pre-BUSD-Payload-activation_20230804', 'post-BUSD-Payload-activation_20230804');
  }
}
