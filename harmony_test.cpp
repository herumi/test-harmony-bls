#include <stdio.h>

int main()
{
#ifdef TEST_OLD
	puts("old test");
#elif defined(TEST_NEW)
	puts("new test");
#else
	"error compile error"
#endif
}
