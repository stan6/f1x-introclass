/**/
#include <stdio.h>
#include <math.h>

int main ()
{
	int int1, int2, int3, int4, tmp;
	printf("Please enter 4 numbers separated by spaces > ");
	scanf("%i%i%i%i", &int1, &int2, &int3, &int4);
	tmp = int1;
	if (tmp > int2)
	tmp = int2;
	if (tmp > int3)
	tmp = int3;
	if (tmp > int4)
	tmp = int4;

	printf("%i is the smallest\n", tmp);

	return 0;
}
