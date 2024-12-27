// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/lib/forge-std/src/Script.sol";
import "../src/Nft.sol";

contract DeployScript is Script {
    function run() external returns (QodoNFT) {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the NFT contract
        QodoNFT nft = new QodoNFT();

        vm.stopBroadcast();
        return nft;
    }
}
