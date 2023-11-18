// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/Xfers.sol";
import "../src/pub2prvPlonk_vk.sol" as pub2prvPlonk_vk;
import "../src/prv2prvPlonk_vk.sol" as prv2prvPlonk_vk;
import "../src/prv2pubPlonk_vk.sol" as prv2pubPlonk_vk;

contract Deploy is Script {
    // Test accounts from passphrase in env (not in repo)
    address constant account0 = 0x17eE56D300E3A0a6d5Fd9D56197bFfE968096EdB;
    address constant account1 = 0xFE6A93054b240b2979F57e49118A514F75f66D4e;
    address constant account2 = 0xcEeEa627dDe5EF73Fe8625e146EeBba0fdEB00bd;
    address constant account3 = 0xEf5b07C0cb002853AdaD2B2E817e5C66b62d34E6;

    function run() external {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(); /*deployerPrivateKey*/

        console.log("Creator (owner): ", msg.sender);

        // Deploy verifier contracts
        address v1 = address(new pub2prvPlonk_vk.UltraVerifier());
        address v2 = address(new prv2prvPlonk_vk.UltraVerifier());
        address v3 = address(new prv2pubPlonk_vk.UltraVerifier());

        // Deploy main contract
        Xfers x = new Xfers(v1, v2, v3);
        console.log(
            "Xfers deployed: ",
            address(x)
        );
    }
}
