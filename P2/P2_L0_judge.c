#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
int main()
{
    char a[101];
	
	int N;
	scanf("%d",&N);
	
	int j=0,i;
	
	for(i=0;i<N;i++){
		scanf("%c",&a[i]);
	}
    
    for(i=N-1; i>=0; i--)
    {
        if(a[j]!=a[i]){
        	printf("0");
        	break;
		}
        j++;
        if(j>=i){
        	printf("1");
        	break;
		}
    }
    return 0;
}

