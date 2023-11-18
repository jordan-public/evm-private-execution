const ethers = require('ethers')
const fs = require('fs')

const privateKey1 = ethers.randomBytes(32)
const privateKey1HexString = ethers.hexlify(privateKey1)
fs.writeFileSync('./keys/account1.private_key', privateKey1HexString)

const privateKey2 = ethers.randomBytes(32)
const privateKey2HexString = ethers.hexlify(privateKey2)
fs.writeFileSync('./keys/account2.private_key', privateKey2HexString)

// Check the keys
k1 = fs.readFileSync('./keys/account1.private_key').toString()
k2 = fs.readFileSync('./keys/account2.private_key').toString()
console.log('Verified:', privateKey1HexString === k1 && privateKey2HexString === k2)
