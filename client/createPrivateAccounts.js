// SPDX-License-Identifier: BUSL-1.1
const ethers = require('ethers')
const fs = require('fs')

const privateKey1 = ethers.randomBytes(32)
const privateKey1HexString = ethers.hexlify(privateKey1)
fs.writeFileSync('./keys/account1', privateKey1HexString)

const privateKey2 = ethers.randomBytes(32)
const privateKey2HexString = ethers.hexlify(privateKey2)
fs.writeFileSync('./keys/account2', privateKey2HexString)

// Check the keys
k1 = fs.readFileSync('./keys/account1').toString()
k2 = fs.readFileSync('./keys/account2').toString()
console.log('Private keys verified:', privateKey1HexString === k1 && privateKey2HexString === k2)

// Get the public key 1 and serialized it to a file
const signingKey1 = new ethers.SigningKey(privateKey1HexString)
const publicKey1 = signingKey1.publicKey;
fs.writeFileSync('./keys/account1.pub', publicKey1)

// Get the public key 2 and serialized it to a file
const signingKey2 = new ethers.SigningKey(privateKey2HexString)
const publicKey2 = signingKey2.publicKey;
fs.writeFileSync('./keys/account2.pub', publicKey2)

// Check the public keys
const p1 = fs.readFileSync('./keys/account1.pub').toString()
const p2 = fs.readFileSync('./keys/account2.pub').toString()
console.log('Public keys verified:', publicKey1 === p1 && publicKey2 === p2)
