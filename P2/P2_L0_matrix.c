#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
int main()
{
	int N;
	scanf("%d",&N);
	int A[8][8],B[8][8],C[8][8];
	int i,j,l;
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			scanf("%d",&A[i][j]);
		}
	}
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			scanf("%d",&B[i][j]);
		}
	}
	int sum;
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			sum=0;
			for(l=0;l<N;l++){
				sum+=A[i][l]*B[l][j];
			}
			C[i][j]=sum;
		}
	}
	for(i=0;i<N;i++){
		for(j=0;j<N;j++){
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}
}

