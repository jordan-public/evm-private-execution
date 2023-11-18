const sarma = require('./sarma')
const ethers = require('ethers')
const fs = require('fs')
const { exec } = require('child_process');

const privateKey1 = fs.readFileSync('./keys/account1').toString()
const publicKey2 = fs.readFileSync('./keys/account2.pub').toString()

const inputValue = 2;
// Convert to hex string
const payload = ethers.hexlify(new Uint8Array([inputValue])).slice(2)
console.log('Payload:', payload, typeof payload, payload.length)

const s = sarma.construct(privateKey1, publicKey2, payload)
console.log('Sarma constructed:', s, typeof s, s.length)

// Verify the sarma
const p = sarma.verify(s, privateKey1)
console.log('Sarma payload:', p, typeof p, p.length)
console.log('Payload verified:', payload === p)

// Get the public key 1 and serialized it to a file
const signingKey1 = new ethers.SigningKey(privateKey1)
const publicKey1 = signingKey1.publicKey; // This is a hex string
// console.log('publicKey1', publicKey1, typeof publicKey1, publicKey1.length)

const payloadBytes = ethers.toUtf8Bytes(s.slice(130))
const payloadDigest = ethers.keccak256(payloadBytes)
// console.log('payloadDigest', payloadDigest, typeof payloadDigest, payloadDigest.length)

// Input parameters to the prover
const proverToml = 
    `public_key_x = ${JSON.stringify(Array.from(ethers.getBytes('0x' + publicKey1.slice(4, 68)), byte => byte.toString()))}` + "\n" +
    `public_key_y = ${JSON.stringify(Array.from(ethers.getBytes('0x' + publicKey1.slice(68, 132)), byte => byte.toString()))}` + "\n" +
    `signature = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s.slice(0,128)), byte => byte.toString()))}` + "\n" +
    `privkey = ${JSON.stringify(Array.from(ethers.getBytes(privateKey1), byte => byte.toString()))}` + "\n" +
    `sarma_payload_digest = ${JSON.stringify(Array.from(ethers.getBytes(payloadDigest), byte => byte.toString()))}` + "\n" +
    `sarma = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s), byte => byte.toString()))}` + "\n" +
    `sarma_decrypted = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s), byte => byte.toString()))}`
fs.writeFileSync('../zk/pub2prv_xfer/Prover.toml', proverToml)

// Generate the proof
// Execute the following command in the ../zk/pub2prv_xfer directory
// nargo prove
exec('cd ../zk/pub2prv_xfer && time nargo prove --silence-warnings', (error, stdout, stderr) => {
    if (error) {
        console.error(`exec error: ${error}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
    console.error(`stderr: ${stderr}`);
});

// Execute the following command in the ../zk/pub2prv_xfer directory
// nargo verify
exec('cd ../zk/pub2prv_xfer && time nargo verify --silence-warnings', (error, stdout, stderr) => {
    if (error) {
        console.error(`exec error: ${error}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
    console.error(`stderr: ${stderr}`);
});

