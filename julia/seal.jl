using SEAL

params = EncryptionParameters(SchemeType.bfv)
poly_mod_degree = 4096
set_poly_modulus_degree!(params, poly_mod_degree)
set_coeff_modulus!(params, coeff_modulus_bfv_default(poly_mod_degree))
set_plain_modulus!(params, plain_modulus_batching(poly_mod_degree, 20))

ctx = SEALContext(params)
keygen = KeyGenerator(ctx)

pk = PublicKey()
create_public_key!(pk, keygen)

sk = secret_key(keygen)

enc = Encryptor(ctx, pk)
eva = Evaluator(ctx)
dec = Decryptor(ctx, sk)
encoder = BatchEncoder(ctx)

pod_mat = collect(UInt64, 1:slot_count(encoder))

plain_mat = Plaintext()
encode!(plain_mat, pod_mat, encoder)

enc_mat = Ciphertext()
encrypt!(enc_mat, plain_mat, enc)
print


add_inplace!(enc_mat, enc_mat, eva)

plain_result = Plaintext()
decrypt!(plain_result, enc_mat, dec)
decode!(pod_mat, plain_result, encoder)