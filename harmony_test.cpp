#include <stdio.h>
#include <cybozu/xorshift.hpp>

#ifdef TEST_OLD

#ifndef BLS_SWAP_G
	#error "define BLS_SWAP_G"
#endif

#define MCLBN_FP_UNIT_SIZE 6
#define MCLBN_FR_UNIT_SIZE 4
#include <bls/bls.h>

#elif defined(TEST_NEW) || defined(TEST_ETH)

#ifndef BLS_ETH
	#error "define BLS_ETH"
#endif
#include <bls/bls384_256.h>

#else
	"error compile error"
#endif

#include <string>
#include <vector>
#include <cybozu/atoi.hpp>
#include <cybozu/itoa.hpp>

typedef std::vector<uint8_t> Uint8Vec;

Uint8Vec fromHexStr(const std::string& s)
{
	Uint8Vec ret(s.size() / 2);
	for (size_t i = 0; i < s.size(); i += 2) {
		ret[i / 2] = cybozu::hextoi(&s[i], 2);
	}
	return ret;
}

std::string toHexStr(const uint8_t *buf, size_t n)
{
	std::string s;
	for (size_t i = 0; i < n; i++) {
		s += cybozu::itohex(buf[i], false);
	}
	return s;
}

void putHex(const blsSecretKey& sec)
{
	uint8_t buf[256];
	int n = blsSecretKeySerialize(buf, sizeof(buf), &sec);
	printf("sec=%s\n", toHexStr(buf, n).c_str());
}

void putHex(const blsPublicKey& pub)
{
	uint8_t buf[256];
	int n = blsPublicKeySerialize(buf, sizeof(buf), &pub);
	printf("pub=%s\n", toHexStr(buf, n).c_str());
}

void putHex(const blsSignature& sig)
{
	uint8_t buf[256];
	int n = blsSignatureSerialize(buf, sizeof(buf), &sig);
	printf("sig=%s\n", toHexStr(buf, n).c_str());
}


void test_sign_verify(cybozu::XorShift& rg)
{
	uint8_t secBuf[32];
	rg.read(secBuf, sizeof(secBuf));
	blsSecretKey sec;
	int ret;
	ret = blsSecretKeySetLittleEndianMod(&sec, secBuf, sizeof(secBuf));
	if (ret != 0) {
		puts("err blsSecretKeySetLittleEndianMod");
		return;
	}
	putHex(sec);

	blsPublicKey pub;
	blsGetPublicKey(&pub, &sec);
	putHex(pub);

	const size_t msgSize = 32;
	uint8_t msg[msgSize];
	rg.read(msg, msgSize);
	printf("msg=%s\n", toHexStr(msg, msgSize).c_str());

	blsSignature sig;
	blsSign(&sig, &sec, msg, msgSize);
	putHex(sig);
	ret = blsVerify(&sig, &pub, msg, msgSize);
	if (ret != 1) {
		puts("err blsVerify");
		return;
	}

#if 1
	blsSignHash(&sig, &sec, msg, msgSize);
	putHex(sig);
	ret = blsVerifyHash(&sig, &pub, msg, msgSize);
	if (ret != 1) {
		puts("err blsVerifyHash");
		return;
	}
#endif
}

int main()
{
#ifdef TEST_OLD
	fprintf(stderr, "old test\n");
#elif defined(TEST_NEW)
	fprintf(stderr, "new test\n");
#elif defined(TEST_ETH)
	fprintf(stderr, "eth test\n");
#else
	#error "TEST error"
#endif
	int ret = blsInit(MCL_BLS12_381, MCLBN_COMPILED_TIME_VAR);
	if (ret != 0) {
		puts("err blsInit");
		return 1;
	}
#if defined(TEST_NEW) || defined(TEST_ETH)
	// compatible parameter with the old bls library
	blsSetETHserialization(0);
	blsSetMapToMode(0);
	blsSetETHmode(0);
	{
		const char *genStr = "1 4f58f3d9ee829f9a853f80b0e32c2981be883a537f0c21ad4af17be22e6e9959915ec21b7f9d8cc4c7315f31f3600e5 1212110eb10dbc575bccc44dcd77400f38282c4728b5efac69c0b4c9011bd27b8ed608acd81f027039216a291ac636a8";
		blsPublicKey gen;
		ret = blsPublicKeySetHexStr(&gen, genStr, strlen(genStr));
		if (ret != 0) {
			puts("err blsPublicKeySetHexStr");
			return 1;
		}
		ret = blsSetGeneratorOfPublicKey(&gen);
		if (ret != 0) {
			puts("err blsSetGeneratorOfPublicKey");
			return 1;
		}
	}
#endif
	cybozu::XorShift rg;
	for (int i = 0; i < 3; i++) {
		test_sign_verify(rg);
	}
}

