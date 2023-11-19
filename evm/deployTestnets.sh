#!/bin/zsh

# Run anvil.sh in another shell before running this

# To load the variables in the .env file
source .env

# Scroll Sepolia
forge script script/Deploy.s.sol:Deploy --legacy --rpc-url "https://scroll-testnet-public.unifra.io" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/534351"

# Polygon zkEVM Testnet
forge script script/Deploy.s.sol:Deploy --legacy --rpc-url "https://rpc.public.zkevm-test.net" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/1442"

# Mantle Testnet
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://rpc.testnet.mantle.xyz" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/5001"

# Gnosis Chiado
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://rpc.chiadochain.net" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/10200"

# Linea Testnet
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://rpc.goerli.linea.build" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/59140"

# Neon Devnet
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://devnet.neonevm.org" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/245022940"

# zkSync Era Testnet (fails - needs special handling)
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://testnet.era.zksync.dev" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/280"

# Arbitrum Goerli
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://goerli-rollup.arbitrum.io/rpc" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/421613"

# Base Goerli
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://goerli.base.org" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/84531"

# Celo Alfajores
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://alfajores-forno.celo-testnet.org" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/44787"

# Chiliz Scoville
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://scoville-rpc.chiliz.com" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/88880"

# Filecoin FVM Testnet
#forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://api.calibration.node.glif.io/rpc/v1" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv
forge script script/Deploy.s.sol:Deploy --legacy --slow --rpc-url "https://filecoin-calibration.chainup.net/rpc/v1" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/314159"

# cd web
# npm run build