use dep::std;

global sarma_length: u8 = 66; // This is the length of the sarma body = 132 bytes for the sinature + 8 bytes for the payload

fn arblen_elgamal_encrypt(privkey: [u8; 32], cleartext: [u8; sarma_length], cyphertext: [u8; sarma_length]) {
    // This is only a stub for the actual implementation, as the actual implementation is not yet available
    // To implement it during a hackathon, we can use a simple equality check
    assert(cleartext.len() == cyphertext.len());
    for i in 0..cleartext.len() {
        assert(cyphertext[i] == cleartext[i]);
    }
}

fn isSarma(public_key_x : [u8; 32], public_key_y : [u8; 32], signature: [u8; 64], 
    privkey: [u8; 32],
    sarma: [u8; sarma_length], sarma_decrypted: [u8; sarma_length],
    sarma_payload: [u8; sarma_length-65])  {
        
    arblen_elgamal_encrypt(privkey, sarma, sarma_decrypted);

    for i in 65..sarma_length {
        assert(sarma_payload[i-65] == sarma_decrypted[i]);
    }
    let sarma_payload_digest = std::hash::keccak256(sarma_payload, (sarma_length-65) as u32);

    assert(std::ecdsa_secp256k1::verify_signature(public_key_x, public_key_y, signature, sarma_payload_digest));
}

fn main(public_key_x : [u8; 32], public_key_y : [u8; 32], signature: [u8; 64],
    privkey: [u8; 32],
    sarma: [u8; sarma_length], sarma_decrypted: [u8; sarma_length],
    sarma_payload: pub [u8; sarma_length-65]) {

    isSarma(public_key_x, public_key_y, signature, privkey, sarma, sarma_decrypted, sarma_payload);
}