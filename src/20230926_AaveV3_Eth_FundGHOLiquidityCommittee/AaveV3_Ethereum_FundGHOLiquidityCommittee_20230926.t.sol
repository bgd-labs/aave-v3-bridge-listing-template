// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926} from './AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

/**
 * @dev Test for AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926
 * command: make test-contract filter=AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926
 */
contract AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926_Test is ProtocolV3TestBase {
  AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18222341);
    proposal = new AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926();
  }

  function testProposalExecution() public {
    uint256 daiAmount = 406_000 * 1e18;
    address liquidityCommittee = address(1234); // TODO
    
    // milkman creates intermediary contract for each swap
    // while swap is not executed the assets will be in these swap-specific proxy addresses instead of aaveSwapper
    // proxy contracts addresses are deterministic, they could be derived via code. 
    // I simulated execution and copy pasted the address for simplicity
    // see https://etherscan.io/address/0x11C76AD590ABDFFCD980afEC9ad951B160F02797#code#L878
    address daiMilkmanCreatedContract = 0x2414B7eDd549E62e8a5877b73D96C80bAbC30bca;

    AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926 payload = new AaveV3_Ethereum_FundGHOLiquidityCommittee_20230926();
    
    uint256 balanceBefore = liquidityCommittee.balance;

    GovHelpers.executePayload(vm, address(payload), AaveGovernanceV2.SHORT_EXECUTOR);
    
    uint256 proxyBalanceAfter = IERC20(AaveV3EthereumAssets.DAI_UNDERLYING).balanceOf(daiMilkmanCreatedContract);
    assertEq(proxyBalanceAfter, daiAmount);
    
    uint256 balanceAfter = liquidityCommittee.balance;
    assertEq(balanceAfter, balanceBefore + 5 ether);

    assertEq(
      IERC20(AaveV3EthereumAssets.GHO_UNDERLYING)
        .allowance(address(AaveV3Ethereum.COLLECTOR), liquidityCommittee), 
      daiAmount
    );
  }
}
