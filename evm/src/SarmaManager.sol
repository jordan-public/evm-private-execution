// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SarmaManager {
    bytes[] public sarmas; // sarmaId => sarma
    mapping (bytes32 => uint256) public hashToSarmaId;

    constructor () {
        // Create dummy sarma as sentinel
        sarmas.push("");
    }
    
    function createSarma(bytes calldata sarma) internal {
        bytes32 sarmaHash = keccak256(sarma);
        require(hashToSarmaId[sarmaHash] == 0, "Sarma already exists");
        hashToSarmaId[sarmaHash] = sarmas.length;
        sarmas.push(sarma);
    }

    function destroySarma(bytes calldata sarma) internal {
        bytes32 sarmaHash = keccak256(sarma);
        uint256 sarmaId = hashToSarmaId[sarmaHash];
        require(sarmaId != 0, "Sarma not found");
        delete sarmas[sarmaId];
        hashToSarmaId[sarmaHash] = 0;
    }
}
