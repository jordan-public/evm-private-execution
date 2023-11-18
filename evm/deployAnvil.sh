#!/bin/zsh

# Run anvil.sh in another shell before running this

# To load the variables in the .env file
source .env

cp ../zk/pub2prv_xfer/contract/pub2prv_xfer/plonk_vk.sol src/pub2prvPlonk_vk.sol
cp ../zk/prv2prv_xfer/contract/prv2prv_xfer/plonk_vk.sol src/prv2prvPlonk_vk.sol
cp ../zk/prv2pub_xfer/contract/prv2pub_xfer/plonk_vk.sol src/prv2pubPlonk_vk.sol

# To deploy and verify our contract
forge script script/Deploy.s.sol:Deploy --rpc-url "http://127.0.0.1:8545/" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

source push_artifacts.sh "Deploy.s.sol/31337"

# cd web
# npm run build