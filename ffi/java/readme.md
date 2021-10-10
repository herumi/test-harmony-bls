# use Harmony mcl/bls

```
mkdir work
cd work
git clone https://github.com/harmony-one/mcl
git clone https://github.com/herumi/test-harmony-bls bls
make -C mcl lib/libmcl.a MCL_USE_OPENSSL=0
cd bls
make lib/libbls384_256.so MCL_USE_OPENSSL=0 BLS_SWAP_G=1
cd ffi/java
make MCL_USE_OPENSSL=0 BLS_SWAP_G=1
make test
```
