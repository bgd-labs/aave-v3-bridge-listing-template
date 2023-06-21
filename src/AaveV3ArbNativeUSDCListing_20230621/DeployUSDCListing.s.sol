// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
import {EthereumScript, ArbitrumScript} from 'aave-helpers/ScriptUtils.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveV3ArbNativeUSDCListing_20230621} from 'src/AaveV3ArbNativeUSDCListing_20230621/AaveV3ArbNativeUSDCListing_20230621.sol';

contract DeployArbUSDNPayload is ArbitrumScript {
  function run() external broadcast {
    new AaveV3ArbNativeUSDCListing_20230621();
  }
}

contract USDCNPayloadProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildArbitrum(
      0xA125a7c1c4ef4830Fe7b66A6735862eB6Ff0fbb6
    );
    GovHelpers.createProposal(
      payloads,
      GovHelpers.ipfsHashFile(
        vm,
        'src/AaveV3ArbNativeUSDCListing_20230621/ADD-NATIVE-USDC-ARB-V3-AIP.md'
      )
    );
  }
}