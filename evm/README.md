## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Testnet Deployments

I tried deployments on all following networks. However some are missing the following:

BN128 Pairing Precompile — Address: ```0x08```

See more details: [EIP-196](https://eips.ethereum.org/EIPS/eip-196) and [EIP-197](https://eips.ethereum.org/EIPS/eip-197).

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
