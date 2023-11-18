const sarma = require('./sarma')
const ethers = require('ethers')
const fs = require('fs')
const { execSync } = require('child_process');

const privateKey1 = fs.readFileSync('./keys/account1').toString()
const publicKey2 = fs.readFileSync('./keys/account2.pub').toString()

const inputValue = 1;
// Convert to hex string
//const payload = ethers.hexlify(new Uint8Array([inputValue])).slice(2)
const payload = new Uint8Array([inputValue])
// console.log('Payload:', payload, typeof payload, payload.length)

const s = sarma.construct(privateKey1, publicKey2, payload)
console.log('Sarma constructed:', s, typeof s, s.length)

// Verify the sarma
const p = sarma.verify(s, privateKey1)
// console.log('Sarma payload:', p, typeof p, p.length)
// console.log('Payload:', payload, typeof payload, payload.length)
console.log('Payload verified:', JSON.stringify(payload) === JSON.stringify(p))

// Get the public key 1 and serialized it to a file
const signingKey1 = new ethers.SigningKey(privateKey1)
const publicKey1 = signingKey1.publicKey; // This is a hex string
// console.log('publicKey1', publicKey1, typeof publicKey1, publicKey1.length)

const payloadBytes = ethers.toUtf8Bytes(s.slice(130))
const decoder = new TextDecoder('utf-8');
const hexString = decoder.decode(payloadBytes);
const decimalArray = [parseInt(hexString, 16)];
const payloadUint8Array = new Uint8Array(decimalArray);
const payloadDigest = ethers.keccak256(payloadUint8Array)
// console.log('payloadDigest', payloadDigest, typeof payloadDigest, payloadDigest.length)

// const payloadDigest = ethers.keccak256(payloadBytes)
// console.log('payloadDigest', payloadDigest, typeof payloadDigest, payloadDigest.length)

// Input parameters to the prover
const proverToml = 
    `public_key_x = ${JSON.stringify(Array.from(ethers.getBytes('0x' + publicKey1.slice(4, 68)), byte => byte.toString()))}` + "\n" +
    `public_key_y = ${JSON.stringify(Array.from(ethers.getBytes('0x' + publicKey1.slice(68, 132)), byte => byte.toString()))}` + "\n" +
    `signature = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s.slice(0,128)), byte => byte.toString()))}` + "\n" +
    `privkey = ${JSON.stringify(Array.from(ethers.getBytes(privateKey1), byte => byte.toString()))}` + "\n" +
    `sarma_payload = ${JSON.stringify(Array.from(payload, byte => byte.toString()))}` + "\n" +
    `sarma = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s), byte => byte.toString()))}` + "\n" +
    `sarma_decrypted = ${JSON.stringify(Array.from(ethers.getBytes('0x' + s), byte => byte.toString()))}`
fs.writeFileSync('../zk/prv2pub_xfer/Prover.toml', proverToml)

// Generate the proof
// Execute the following command in the ../zk/prv2pub_xfer directory
// nargo prove
try {
    execSync('cd ../zk/prv2pub_xfer && time nargo prove --silence-warnings', { encoding: 'utf-8' });
} catch (error) {
    console.error('Error occurred:', error);
}

// Execute the following command in the ../zk/prv2pub_xfer directory
// nargo verify
try {
    execSync('cd ../zk/prv2pub_xfer && time nargo verify --silence-warnings', { encoding: 'utf-8' });
} catch (error) {
    console.error('Error occurred:', error);
}

 const sp = '0x' + s + s.slice(130);
 console.log('Sarma + payload: ', sp);

 const proof = '0x' + fs.readFileSync('../zk/prv2pub_xfer/proofs/prv2pub_xfer.proof').toString();
 console.log('Proof: ', proof);

try {
    const command = 'cd ../evm && source .env && cast send $CONTRACT_ADDRESS "prv2pubXfer(bytes,bytes)" ' +
    sp + ' ' + proof + ' --private-key $PRIVATE_KEY --rpc-url $RPC_URL';
    console.log('Command:', command)
    const output = execSync(command, { encoding: 'utf-8' });
    console.log('Output:', output);
} catch (error) {
    console.error('Error occurred:', error);
}
