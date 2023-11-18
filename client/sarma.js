const arblen_elgamal = require('./arblen_elgamal')
const ethers = require('ethers')

function toHexString(byteArray) {
    result = ''
    for (let i = 0; i < byteArray.length; i++) {
        result += ('0' + byteArray[i].toString(16)).slice(-2)
    }
    return result;
}

function construct(privkey, recepient_pubkey, payload) {
    // console.log('Payload:', payload, typeof payload)
    // Sign the payload
    const signingKey = new ethers.SigningKey(privkey) // privkey us a hex string
    // const payloadBytes = ethers.toUtf8Bytes(payload)
    // const digest = ethers.keccak256(payloadBytes)
    // console.log('payload', payload, typeof payload, payload.length)
    const digest = ethers.keccak256(payload)
    // console.log('digest', digest, typeof digest, digest.length)
    const signature = signingKey.sign(digest)
    
    // Verify the signature
    const recoveredPublicKey = ethers.SigningKey.recoverPublicKey(digest, signature)
    if (recoveredPublicKey !== signingKey.publicKey) {
        throw new Error("Signature mismatch")
    }
    // console.log("publicKey", signingKey.publicKey, typeof signingKey.publicKey, signingKey.publicKey.length)
    // console.log("signature", JSON.stringify(signature))
    const signatureHexString = signature.r.slice(2) + signature.s.slice(2) + signature.v.toString(16)
    // console.log("signatureHexString", signatureHexString, typeof signatureHexString, signatureHexString.length)
    const sarma = arblen_elgamal.encrypt(recepient_pubkey, signatureHexString + toHexString(payload))
    // console.log('Sarma constructed:', sarma, typeof sarma, sarma.length)
    return sarma
}

function verify(sarma, privkey) {
    const decryptedSarma = arblen_elgamal.decrypt(privkey, sarma)
    const signature = decryptedSarma.slice(0, 130)
    const payloadBytes = ethers.getBytes('0x' + decryptedSarma.slice(130))
    const digest = ethers.keccak256(payloadBytes)
    const signatureObject = {
        r: '0x' + signature.slice(0, 64),
        s: '0x' + signature.slice(64, 128),
        v: parseInt(signature.slice(128), 16)
    }
    // console.log("signatureObject", JSON.stringify(signatureObject))
    const recoveredPublicKey = ethers.SigningKey.recoverPublicKey(digest, signatureObject)
    // console.log("recoveredPublicKey", recoveredPublicKey, typeof recoveredPublicKey, recoveredPublicKey.length)
    const signingKey = new ethers.SigningKey(privkey) // privkey us a hex string
    // console.log("signingKey.publicKey", signingKey.publicKey, typeof signingKey.publicKey, signingKey.publicKey.length)
    if (recoveredPublicKey !== signingKey.publicKey) {
        throw new Error("Signature mismatch")
    }
    //return decryptedSarma.slice(130)
    return payloadBytes
}

module.exports = {
    construct,
    verify
}
