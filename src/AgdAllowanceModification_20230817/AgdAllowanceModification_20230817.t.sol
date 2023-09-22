// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {ProtocolV2TestBase} from 'aave-helpers/ProtocolV2TestBase.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveMisc} from 'aave-address-book/AaveMisc.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {AgdAllowanceModification_20230817} from './AgdAllowanceModification_20230817.sol';

contract AgdAllowanceModification_20230817_Test is ProtocolV2TestBase {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18166945);
  }

  function testpayload() public {

    address AGD_MULTISIG = 0x89C51828427F70D77875C6747759fB17Ba10Ceb0;

    // milkman creates intermediary contract for each swap
    // while swap is not executed the assets will be in these addresses instead of aaveSwapper;
    address usdcMilkmanCreatedContract = 0x2414B7eDd549E62e8a5877b73D96C80bAbC30bca;
    address usdtMilkmanCreatedContract = 0x86487dad62c99A37d0052ed56BF1EafF2959294D;

    uint256 usdcAmount = 228_000 * 1e6;
    uint256 usdtAmount = 150_000 * 1e6;

    uint256 usdcBalanceBefore = IERC20(AaveV3EthereumAssets.USDC_UNDERLYING).balanceOf(AaveMisc.AAVE_SWAPPER_ETHEREUM);
    uint256 usdtBalanceBefore = IERC20(AaveV3EthereumAssets.USDT_UNDERLYING).balanceOf(AaveMisc.AAVE_SWAPPER_ETHEREUM);
    uint256 aDaiAllowanceBefore = IERC20(AaveV2EthereumAssets.DAI_A_TOKEN)
      .allowance(address(AaveV2Ethereum.COLLECTOR), AGD_MULTISIG);

    AgdAllowanceModification_20230817 payload = new AgdAllowanceModification_20230817();

    GovHelpers.executePayload(vm, address(payload), AaveGovernanceV2.SHORT_EXECUTOR);

    /// check if swapper got the assets to swap
    uint256 usdcBalanceAfter = IERC20(AaveV3EthereumAssets.USDC_UNDERLYING).balanceOf(usdcMilkmanCreatedContract);
    uint256 usdtBalanceAfter = IERC20(AaveV3EthereumAssets.USDT_UNDERLYING).balanceOf(usdtMilkmanCreatedContract);

    assertEq(usdcBalanceAfter, usdcBalanceBefore + usdcAmount);
    assertEq(usdtBalanceAfter, usdtBalanceBefore + usdtAmount);

    /// check allowances are correctly set

    assertEq(
      IERC20(AaveV2EthereumAssets.DAI_A_TOKEN)
        .allowance(address(AaveV2Ethereum.COLLECTOR), AGD_MULTISIG),
      0
    );
    assertEq(
      IERC20(AaveV3EthereumAssets.GHO_UNDERLYING)
        .allowance(address(AaveV2Ethereum.COLLECTOR), AGD_MULTISIG), 
      aDaiAllowanceBefore
    );
  }
}
