OLD=old
NEW=new
all: harmony_test_old.exe harmony_test_new.exe


SRC=harmony_test.cpp
CFLAGS=-O2 -NDEBUG -Wall -Wextra
OLD_CFLAGS=-DBLS_SWAP_G -I $(OLD)/mcl/include -I $(OLD)/bls/include -DTEST_OLD
OLD_LDFLAGS=-L $(OLD)/lib -L $(OLD)/mcl/lib

NEW_CFLAGS=-DBLS_ETH -I $(NEW)/bls/include -I $(NEW)/bls/mcl/include -DTEST_NEW
NEW_LDFLAGS=-L $(NEW)/lib -L $(NEW)/mcl/lib

OLD_LIB=$(OLD)/bls/lib/libbls384_256.a
NEW_LIB=$(NEW)/bls/lib/libbls384_256.a

$(OLD_LIB):
	$(MAKE) -C $(OLD)/mcl
	$(MAKE) -C $(OLD)/bls BLS_SWAP_G=1

$(NEW_LIB):
	$(MAKE) -C $(NEW)/bls BLS_ETH=1

harmony_test_old.o: harmony_test.cpp
	$(CXX) -c $< -o $@ -MMD -MP -MF $(@:.o=.d) $(OLD_CFLAGS)

harmony_test_new.o: harmony_test.cpp
	$(CXX) -c $< -o $@ -MMD -MP -MF $(@:.o=.d) $(NEW_CFLAGS)

harmony_test_old.exe: harmony_test_old.o $(OLD_LIB)
	$(CXX) $< -o $@ $(OLD_LDFLAGS) $(OLD_LIB)

harmony_test_new.exe: harmony_test_new.o $(NEW_LIB)
	$(CXX) $< -o $@ $(NEW_LDFLAGS) $(NEW_LIB)

