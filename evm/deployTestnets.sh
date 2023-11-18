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

# cd web
# npm run build