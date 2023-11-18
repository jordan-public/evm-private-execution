const sarma = require('./sarma')
const fs = require('fs')

const privateKey1 = fs.readFileSync('./keys/account1').toString()
const publicKey2 = fs.readFileSync('./keys/account2.pub').toString()

const payload = 'Hello world!'
const s = sarma.construct(privateKey1, publicKey2, payload)

// Verify the sarma
const p = sarma.verify(s, privateKey1)
console.log('Sarma payload:', p, typeof p, p.length)
console.log('Payload verified:', payload === p)

