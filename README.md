[This project](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o) won the following prizes at the [ETHGlobal Istanbul 2023](https://ethglobal.com/events/istanbul) hackathon:


🏊 [Filecoin — Pool Prize](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏊 [Arbitrum — Pool Prize](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏊 [Chiliz — Pool Prize](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏆 [Linea — Best dApp on Linea](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🔀 [Polygon — Best Cross-chain / LxLy Bridge implementation](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🚀 [Scroll — Deploy on Scroll](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏆 [Aleo - Grand Prize](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏆 [Aztec — Best overall Noir application or library](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🥇 [Neon Foundation — 1st Place Best Neon EVM use case](https://ethglobal.com/showcase/sarma-evm-zkevm-pexc-9wp7o)

🏆 [Scaling Ethereum Finalist](https://ethglobal.com/showcase/cfd-dex-and-flash-trillions-ad666) - Finalist presentaion [here](https://youtu.be/RW6qZTEIqWc?t=2609)

# Sarma - Private Transaction System for EVM with cross-chain ability

Demo is [here](./demo/README.md).

Video is [here](./demo/Sarma.mp4) and on YouTube [here](https://youtu.be/TQwNU1_pgeE).

ETHGlobal Istanbul finalist presentation is [here](https://youtu.be/RW6qZTEIqWc?t=2609).

## Abstract

I implemented a proof of concept solution for EVM private transactions (function calls, not just asset transfers)
and addresses
using my simple primitive: the Sarma. The Sarma is an encrypted blob of data, which is transferred by the EVM Smart
Contract from address to address, without knowing what is inside, but under a condition that a ZK proof verifies to
allow this movement. In addition, the Sarma can travel across EVM blockchains making the bridge even less corruptible, thus safer, as it does not know what it is transferring. 

The Sarma is modeled after the Aleo "record" primitive, with addition to El Gamal encryption the cross-user secrecy on EVMs.

In my solution the public part of the Smart Contracts is written in Solidity, and the private part in Noir.

## Introduction

In the Ethereum blockchain and its Ethereum Virtual Machine (EVM) all data is public. However, many use cases require private transactions where the data passed from Smart Contract call to another is private and stored privately on-chain. Various privacy blockchains have emerged, achieving this feature, of which most notable are Aleo, Aztec and Mina (in alphabetical order). They utilize Cryptographic Zero Knowledge techniques to achieve this. Despite their remarkable achievements, they do not leverage on the existing EVM Solidity code base but rely on cross-chain or layer 2 transfers into the "private" realm. 

I am leveraging on the Aleo and Noir (by Aztec) to create private transaction and private address ability without leaving the EVM.

Aleo has achieved the public/private duality using an extremely simple primitive called **Record**. The record is an encrypted ```struct``` owned by a specific user, visible only to that user. Their Leo
domain-specific programming language has functions with 2 parts:
-  ```transition```, which creates a ZK proof, which is checked on-chain. In it, the ```record```s are visible. 
- ```finalize```, which after verifying the proof created by the ```transition``` it executes public code in which the ```record```s are not visible unless parts of them are revealed as public inputs in the ZK proof created in the ```transition```.

The ```record``` in Aleo resembles an Unspent Transaction Output (UTXO) in Bitcoin, but it can contain anything, not just tokens/assets. Any
information that needs privacy.

To re-confirm the validity of this idea, the upcoming Aztec Layer 2 blockchain is using a very similar technique technique.

Verifying ZK proofs can be done on-chain on the EVM. However, storing private data on-chain is implemented in Aleo, as they control the code base. But I don't control the EVM code base, so how did I do this? Read on...

## Solution - the **Sarma**

### The Sarma rules

The Sarma corresponds to an Aleo ```record```. To the EVM it's an encrypted blob of data, that the EVM can only move around, without knowing what is in it. Yet, it is not just a blob, because the EVM Smart Contract needs a permission to move this blob, which is governed by a verification of a ZK proof created off-chain. What is the condition, is up to the application developer.

As usual, the public execution is performed by the EVM Smart Contracts, which usually associate data to public addresses (accounts).

The private part is completely separate:
- Callers usually have private addresses (public keys). They exchange the public keys between each other privately, in secret from the other participants.
- All information processing is done inside of the ZK proof. In order to move the Sarmas around, the Solidity part has to get the OK by verifying the ZK proof on-chain as a ```require```ment.
- The communication channel between the public and private 
parts of the code is the set of public inputs in the ZK proof.

### Sarma exchange between callers

Even though the Sarma is not visible by the EVM, it can be decrypted off-chain and verified inside the ZK proof. For this we need to 
- be able to hand over and encrypt/decrypt the Sarma from one user to another, where the users know only each other's public keys of their private addresses,
- be able to do the above non-interactively,
- the Sarma should remain decrypted (invisible) to all other participants.

Luckily, El Gamal encryption achieves this. Each Sarma creator
encrypts the Sarma with the public key of the recipient.
For this they don't need to talk to each other to exchange the information which is otherwise invisible to all others.

To hand over the Sarma,
- Alice encrypts the Sarma using Bob's public key.
- Bob, without talking to Alice, decrypts the Sarma using his private key.

Bob can decrypt the Sarma at any time, but cannot own it until the EVM Smart Contract hands it over to him, in terms of programmable logic.

### Cross-chain Sarma Transfers

While Aleo is a single Layer 1 blockchain, bridges need to be developed to transfer messages (thus assets) to other blockchains. 

Aztec is a Layer 2 blockchain which relies on its sequencer to transfer messages (thus assets) to Layer 1 (Ethereum). 

In my solution, many cross-chain EVM solutions already exist, with proven track record of safety and audits. Namely, the Sarma can travel cross-chain using any of these bridges.

In addition, the Sarma makes the cross-chain bridges safer, as they do not know what they are transferring, making them harder to bribe.

## Implementation

### User perspective

The public part of the Smart Contracts can be written in Solidity. I only provide a contract ```SarmaManager``` which manages the lifetime of the Sarmas. The SolidityDeveloper can simply subclass this contract and create Sarmas using
 ```createSarma``` or destroy/spend them using ```destroySarma```. The Solidity contract should import the
 zk verifiers written in Noir and ```require(verify(...))```
 on each sarma in order to enforce the conditions stated in the zk proof written in Noir.

The private part of the Smart Contract can be written in Noir, as long as the library ```isSarma``` function is called to place the constraints that the public input Sarma has to compliy with. In addition, besides calling ```isSarma```, the developer can put constraints that shape
other logic.

If you know Solidity and Noir, and JavaScript for the front-end, you can already use the Sarma to achieve private addresses and transactions on EVM and across EVMs and write such Web3 applications.

### What is inside?

The **private key** of the private address is a randomly generated point on the elliptic curve. The **public key** of the private address can be calculated from it, and sent to other participants or broadcasted.

The Sarma is created on the client side, encrypted with the intended recipient's public key. This encryption has to be checked (as constraint) in the ZK proof by calling ```isSarma(...)```, to make sure it's a valid Sarma. 

The EVM Smart Contract whenever touching the Sarma would have to call ```verify(...)``` which calls verification function of the ZK proof generated by the Noir's Nargo utility. 

That's it - simple.

### Demo code

I have implemented a simple Smart Contract which allows for:
- public-to-private token minting,
- private-to-private token transfer,
- private-to-public token transfer

In addition I implemented a mock-up Smart Contract which emulates Hyperlink cross-chain message transfer, but it transfers the message back to the same blockchain, for faster development. 

See [this](./demo/README.md) for instructions.

## Future work - Idempotent Sarma Transitions

Let us define an **Idempotent** transition $T$:

$\forall x: T(T(x, y), y) = T(x, y)$

We have to stretch the above definition recursively as **Eventual Idempotency**, stating that a repetition of the transition in a sequence, does not change anything if one of the operations in the sequence is repeated at any time.

Why is this interesting? If we create Sarma Transitions that are Idempotent the intermediate Sarmas do not even need to be stored on the EVM. Just the final result. 

Example: Voting. Let's count the votes for a certain outcome by storing them in a Sparse Merkle Tree (SMT), and produce a recursive proof that the new voter was not in the tree, so he cannot vote twice. We do not need to make the constraints such that the proof fails if the voter tries to vote twice. Instead, we let them vote twice, but the resulting SMT to be the same as if the voter voted once. Yet, allow the proof to succeed by shaping the constraints properly. If the root of this SMT is recorded in a Sarma at the beginning we would not need to record the Sarmas on-chain each time - only at the end.

Proving Idempotency is hard, but enforcing is not so hard: all we need is to enforce it. So, to implement this, one Noir function call would contain an check of Idempotency after the fact. If it passes, no Sarma is recorded on-chain, unless the user "insists". This would not be a constraint, but merely a "shortcut".

This is very easy to implement.

## FAQ

Q: The Sarmas are associated with addresses, does this not break the privacy? 
<br/>
A: Not at all. The public execution can be called by public addresses, but the private addresses do not have to be associated to them. In addition, the public Solidity code can "mint" Sarmas seemingly "out of thin air", but the private Noir code governs the validity of the program logic, as long as the Solidity code verifies the Sarma by calling ```verify```.

Q: What does Sarma mean?
<br/>
A: Since this hackathon is in Türkiye, in Turkish "sarma" means "wrapping". I use the term to denote an encrypted controlled record. In Macedonian (the word coming from the Otoman Empire) "sarma" ("сарма") is rice and meat wrapped in pickled cabbage leaves. Try it - it's yummy.

Q: Is his fast?
<br/>
A: Yes, there is no on-chain proving, thus no on-chain heavy computation. Only verifications occur on-chain, and there is a helpful pre-compile already in most EVMs to make the verification fast. Executing a small amount of public code is faster, but for private transactions, as the code is executed off-chain, the execution happens in constant time and cost, regardless of the amount of calculations.

Q: How come we do not need a tree to store the Sarmas, as Aleo stores its "records" in a Sparse Merkle Tree?
<br/>
A: The Sarmas are stored and governed by the EVM Smart Contract. The EVM is responsible for storing them. However, in order to hide the Sarmas the private and the public address spaces are separated. Even though the movement of Sarmas can be observed, the EVM Smart Contract acts as a "mule" and does know what it is moving. In addition to this, each function call to the EVM Smart Contract can be performed from a different address (EOA). Actually some knowledge about the Sarma movements is revealed, but this knowledge is useless and thus irrelevant.