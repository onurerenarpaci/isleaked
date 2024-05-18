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

plain = 4

plain_value = Plaintext()
encode!(plain_value, plain, encoder)

encrypted_value = Ciphertext()
encrypt!(encrypted_value, plain_value, ctx)

add_inplace!(encrypted_value, encrypted_value, eva)

plain_result = Plaintext()
decrypt!(plain_result, encrypted_value, ctx)
decode!(plain, plain_result, encoder)

plain_result