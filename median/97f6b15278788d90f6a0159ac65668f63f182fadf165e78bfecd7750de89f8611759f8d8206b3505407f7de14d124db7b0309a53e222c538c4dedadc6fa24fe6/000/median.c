/**/
#include <stdio.h>
#include <math.h>
int main(){
int a, b, c, median;
printf("Please enter 3 numbers separated by spaces > ");
scanf("%d%d%d", &a, &b, &c);
if (a > b && a < c)
	median = a;
else if (b > a && b < c)
	median = b;
else if (c > a && c < b)
	median = c;
printf("%d is the median\n", median);
return 0;}