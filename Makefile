OLD=old
NEW=new
TARGET=harmony_test_old.exe harmony_test_new.exe

all: $(TARGET)

SRC=harmony_test.cpp
CFLAGS=-O2 -NDEBUG -Wall -Wextra
LDFLAGS=-lgmp -lgmpxx -lcrypto -lpthread
OLD_CFLAGS=-DBLS_SWAP_G -I $(OLD)/mcl/include -I $(OLD)/bls/include -DTEST_OLD
OLD_LDFLAGS=-L $(OLD)/lib -L $(OLD)/mcl/lib $(LDFLAGS)
OLD_LIB=$(OLD)/bls/lib/libbls384_256.a $(OLD)/mcl/lib/libmcl.a

NEW_CFLAGS=-DBLS_ETH -I $(NEW)/bls/include -I $(NEW)/bls/mcl/include -DTEST_NEW
NEW_LDFLAGS=-L $(NEW)/lib -L $(NEW)/mcl/lib $(LDFLAGS)
NEW_LIB=$(NEW)/bls/lib/libbls384_256.a $(NEW)/bls/mcl/lib/libmcl.a

ETH?=../bls-eth-go-binary
ETH_LIB=$(ETH)/bls/lib/linux/amd64/libbls384_256.a
ETH_CFLAGS=-DBLS_ETH -I $(ETH)/bls/include -I $(ETH)/bls/mcl/include -DTEST_ETH
ETH_LDFLAGS=-L $(ETH)/lib -L $(ETH)/mcl/lib $(LDFLAGS)

$(OLD_LIB):
	$(MAKE) -C $(OLD)/mcl
	$(MAKE) -C $(OLD)/bls BLS_SWAP_G=1

$(NEW_LIB):
	$(MAKE) -C $(NEW)/bls BLS_ETH=1

harmony_test_old.o: harmony_test.cpp
	$(CXX) -c $< -o $@ -MMD -MP -MF $(@:.o=.d) $(OLD_CFLAGS)

harmony_test_new.o: harmony_test.cpp
	$(CXX) -c $< -o $@ -MMD -MP -MF $(@:.o=.d) $(NEW_CFLAGS)

harmony_test_eth.o: harmony_test.cpp
	$(CXX) -c $< -o $@ -MMD -MP -MF $(@:.o=.d) $(ETH_CFLAGS) -I $(NEW)/bls/mcl/include

harmony_test_old.exe: harmony_test_old.o $(OLD_LIB)
	$(CXX) $< -o $@ $(OLD_LIB) $(OLD_LDFLAGS)

harmony_test_new.exe: harmony_test_new.o $(NEW_LIB)
	$(CXX) $< -o $@ $(NEW_LIB) $(NEW_LDFLAGS)

harmony_test_eth.exe: harmony_test_eth.o $(ETH_LIB)
	$(CXX) $< -o $@ $(ETH_LIB) $(ETH_LDFLAGS)

test: $(TARGET)
	./harmony_test_old.exe > old.txt
	./harmony_test_new.exe > new.txt
	diff -urN old.txt new.txt

test_eth: $(TARGET) harmony_test_eth.exe
	./harmony_test_new.exe > new.txt
	./harmony_test_eth.exe > eth.txt
	diff -urN new.txt eth.txt

clean:
	$(RM) -rf $(TARGET) *.o *.d
