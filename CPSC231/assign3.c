#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define  SIZE 50

int main(){
     int v[SIZE],i,j,temp;
     for (i = 0; i < SIZE; i++)
     {
         v[i] = rand() & 0xff;
         printf("v[%d]: %d\n", i, v[i]);
     }
     for (i = 1;i < SIZE;i++)
     {
          temp = v[i];
          for (j = i; j > 0 &&  temp < v[j-1];j--) 
          {
              v[j] = v[j-1];
          } 
          v[j] = temp;
     }
     
     printf("\nSorted array:\n");
     for (i = 0 ;i < SIZE; i++ )
          printf("v[%d]: %d\n",i,v[i]);
}
