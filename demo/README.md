# Demo

## Video

The video is [here](./Sarma.mp4) or on YouTube [here](https://youtu.be/TQwNU1_pgeE).

## Demo instructions

Create the private accounts:
```
cd client
node createPrivateAccounts.js
```
Observe the files in ```client/keys```.

There are 3 types of transactions implemented in the example:

Public to private, transfers 2 beans from the EVM contract to the private account:
```
cd client
node public_to_private_execution.js
```

Private to private, spends 2 beans, 1 goes back to the original owner and 1 to the new owner:
```
cd client
node private_to_private_execution.js
```

Private to public, spends 1 bean and transfers it to the EVM contract:
```
cd client
node private_to_public_execution.js
```

## Testnet Deployments

I tried deployments on all following networks. However some are missing the following:

alt_bn128 (or bn254, or bn256; all three popular names are equivalent) Pairing Precompile — Address: ```0x09```

See more details: [EIP-196](https://eips.ethereum.org/EIPS/eip-196).

Here are the networks (some missing the above pre-compiles fail the proof verification):

- Scroll Sepolia
- Polygon zkEVM Testnet
- Mantle Testnet
- Gnosis Chiado
- Linea Testnet
- Neon Devnet
- zkSync Testnet (foundry deployment fails)
- Arbitrum Goerli
- Base Goerli
- Celo Alfajores
- Chiliz Scoville
- Filecoin FVM Testnet
