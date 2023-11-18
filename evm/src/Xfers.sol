// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./SarmaHandler.sol";
import "./SarmaManager.sol";

contract Xfers is SarmaManager {
    SarmaHandler public pub2prvVerifier;
    SarmaHandler public prv2prvVerifier;
    SarmaHandler public prv2pubVerifier;

    uint8 beans = 3;

    uint256 constant SARMA_SIZE = 66;
    uint256 constant SARMA_PAYLOAD_SIZE = 1;

    constructor(address _pub2prvVerifier, address _prv2prvVerifier, address _prv2pubVerifier) {
        pub2prvVerifier = SarmaHandler(_pub2prvVerifier);
        prv2prvVerifier = SarmaHandler(_prv2prvVerifier);
        prv2pubVerifier = SarmaHandler(_prv2pubVerifier);
    }

    function pub2prvXfer(bytes calldata sarmaToCreate, bytes calldata proof) external {
        bytes32[] memory publicInputs = new bytes32[](SARMA_SIZE + SARMA_PAYLOAD_SIZE);
        for (uint256 i = 0; i < SARMA_SIZE+SARMA_PAYLOAD_SIZE; i++) {
            publicInputs[i] = bytes32(sarmaToCreate[i]);
        }
        require(pub2prvVerifier.verify(proof, publicInputs), "Unauthorized");

        // Create Sarma UTXO and deduct beans
        createSarma(sarmaToCreate);
        bytes memory singleByte = new bytes(1);
        singleByte[0] = sarmaToCreate[SARMA_SIZE];
        uint8 payload = abi.decode(singleByte, (uint8));
        assert(beans >= payload);
        beans -= payload;
    }

    function prv2prvXfer(
        bytes calldata sarmaToDestroy,
        bytes calldata sarma1ToCreate,
        bytes calldata sarma2ToCreate,
        bytes calldata proof) external {
        {
        bytes32[] memory publicInputs = new bytes32[](3 * SARMA_SIZE + 3 * SARMA_PAYLOAD_SIZE);
        for (uint256 i = 0; i < SARMA_SIZE+SARMA_PAYLOAD_SIZE; i++) {
            publicInputs[i] = bytes32(sarmaToDestroy[i]);
        }
        for (uint256 i = 0; i < SARMA_SIZE+SARMA_PAYLOAD_SIZE; i++) {
            publicInputs[i + SARMA_SIZE + SARMA_PAYLOAD_SIZE] = bytes32(sarma1ToCreate[i]);
        }
        for (uint256 i = 0; i < SARMA_SIZE+SARMA_PAYLOAD_SIZE; i++) {
            publicInputs[i + 2*SARMA_SIZE + 2*SARMA_PAYLOAD_SIZE] = bytes32(sarma2ToCreate[i]);
        }
        require(prv2prvVerifier.verify(proof, publicInputs), "Unauthorized");
        }

        // Create Sarma UTXO and deduct beans
        {
        bytes memory singleByte = new bytes(1);
        singleByte[0] = sarmaToDestroy[SARMA_SIZE];
        uint8 payloadToDestroy = abi.decode(singleByte, (uint8));
        singleByte[0] = sarma1ToCreate[SARMA_SIZE];
        uint8 payload1ToCreate = abi.decode(singleByte, (uint8));
        singleByte[0] = sarma2ToCreate[SARMA_SIZE];
        uint8 payload2ToCreate = abi.decode(singleByte, (uint8));
        assert(payloadToDestroy == payload1ToCreate + payload2ToCreate);
        }

        destroySarma(sarmaToDestroy);
        createSarma(sarma1ToCreate);
        createSarma(sarma2ToCreate);
    }

    function prv2prvXfer(
        bytes calldata sarmaToDestroy, bytes calldata sarmaToDestroyPayload,
        bytes calldata proof) external {

        bytes32[] memory publicInputs = new bytes32[](67);
        for (uint256 i = 0; i < SARMA_SIZE; i++) {
            publicInputs[i] = bytes32(sarmaToDestroy[i]);
        }
        publicInputs[SARMA_SIZE] = bytes32(sarmaToDestroyPayload);
        require(prv2prvVerifier.verify(proof, publicInputs), "Unauthorized");

        // Create Sarma UTXO and deduct beans
        uint8 payloadToDestroy = abi.decode(sarmaToDestroyPayload, (uint8));
        beans += payloadToDestroy;

        destroySarma(sarmaToDestroy);        
    }

}
