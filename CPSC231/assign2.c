#include <stdio.h>
#define FALSE 0
#define TRUE  1

int main()
{
	int multiplier,multiplicand,product,i,negative;
	long int result, temp1, temp2;

	multiplicand = -16843010;
	multiplier = 70;
	product = 0;

	printf("multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n",multiplier,multiplier,multiplicand,multiplicand);

	negative = multiplier < 0 ? TRUE : FALSE;

	for (i = 0; i<32; i++){
		if (multiplier & 0x1){
			product = product + multiplicand;
		}
		multiplier = multiplier >> 1;
		if (product & 0x1){
			multiplier = multiplier | 0x80000000;
		}else{
			multiplier = multiplier & 0x7FFFFFFF;
		}
		product = product >> 1;
		printf("product =%d\n, multiplier =%d\n",product,multiplier);

	}
	if (negative){
		product = product - multiplicand;
		printf("product = %d\n",product);
	}
	printf("product = 0x%08x (%d)  multiplier = 0x%08x (%d)\n",product,multiplier);
	temp1 = (long int)product & 0xFFFFFFFF;
	temp1 = temp1 << 32;
	temp2 = (long int)multiplier & 0xFFFFFFFF;
	result = temp1 + temp2;
	
	printf("64-bit result = 0x%0161x (%ld)\n", result, result);
	return 0;
}
