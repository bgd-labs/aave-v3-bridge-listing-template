// SPDX-License-Identifier: MIT

/*
   _      ΞΞΞΞ      _
  /_;-.__ / _\  _.-;_\
     `-._`'`_/'`.-'
         `\   /`
          |  /
         /-.(
         \_._\
          \ \`;
           > |/
          / //
          |//
          \(\
           ``
     defijesus.eth
*/

pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveSwapper} from 'aave-helpers/swaps/AaveSwapper.sol';
import {AaveMisc} from 'aave-address-book/AaveMisc.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

/**
 * @dev (1) Swap aEthUSDC & aEthUSDT to GHO; (2) Replace Aave Grants DAO’s (AGD) DAI allowance with a GHO allowance.
 * @author defijesus.eth - TokenLogic
 * - Snapshot: https://snapshot.org/#/aave.eth/proposal/0x53728c0416a9063bf833f90c3b3169fa4387e66549d5eb2b7ed2747bfe7c23fc
 * - Discussion: https://governance.aave.com/t/arfc-treasury-management-replace-agd-s-dai-allowance-with-gho-allowance/14631
 */
contract TokenLogicFunding_20230919 is IProposalGenericExecutor {

  struct Asset {
    address underlying;
    address aToken;
    address oracle;
    uint256 amount;
  }
  
  function execute() external {
    address TOKENLOGIC = 0x3e4A9f478C0c13A15137Fc81e9d8269F127b4B40;
    address MILKMAN = 0x11C76AD590ABDFFCD980afEC9ad951B160F02797;
    address PRICE_CHECKER = 0xe80a1C615F75AFF7Ed8F08c9F21f9d00982D666c;

    uint256 START_STREAM_TIME = 1695089997; /// 2023/09/19
    uint256 END_STREAM_TIME = 1710645493; /// 2024/03/17

    Asset memory DAI = Asset({
      underlying: AaveV3EthereumAssets.DAI_UNDERLYING,
      aToken: AaveV3EthereumAssets.DAI_A_TOKEN,
      oracle: 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9,
      amount: 350_000 * 1e18
    });

    Asset memory GHO = Asset({
      underlying: AaveV3EthereumAssets.GHO_UNDERLYING,
      aToken: address(0), // not used
      oracle: 0x3f12643D3f6f874d39C2a4c9f2Cd6f2DbAC877FC,
      amount: 350_000 * 1e18
    });

    AaveSwapper SWAPPER = AaveSwapper(AaveMisc.AAVE_SWAPPER_ETHEREUM);

    /// 1. withdraw DAI & swap to GHO

    AaveV3Ethereum.COLLECTOR.transfer(DAI.aToken, address(this), DAI.amount);

    uint256 SWAPPER_DAI_BALANCE = 
      AaveV3Ethereum.POOL.withdraw(DAI.underlying, DAI.amount, AaveMisc.AAVE_SWAPPER_ETHEREUM);

    SWAPPER.swap(
      MILKMAN,
      PRICE_CHECKER,
      DAI.underlying,
      GHO.underlying,
      DAI.oracle,
      GHO.oracle,
      address(AaveV3Ethereum.COLLECTOR),
      SWAPPER_DAI_BALANCE,
      150
    );

    /// 2. create GHO stream
    /// TODO: figure out this out, the remainder of the division between gho amount and timestamp delta should be zero
    /// probably set start time to 1 month from now and then end = +180 days. amount should be finetuned to fit the timestamps
    AaveV3Ethereum.COLLECTOR.createStream(
      TOKENLOGIC, GHO.amount, 
      GHO.underlying, 
      block.timestamp, 
      block.timestamp + 180 days
    );
  }
}