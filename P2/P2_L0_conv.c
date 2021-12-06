#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
int main()
{
	int A[10][10];
	int B[10][10];
	
	int m1,n1;
	int m2,n2;
	
	scanf("%d%d",&m1,&n1);
	scanf("%d%d",&m2,&n2);
	
	int i,j,k,l;
	
	for(i=0;i<m1;i++){
		for(j=0;j<n1;j++){
			scanf("%d",&A[i][j]);
		}
	}
	
	for(i=0;i<m2;i++){
		for(j=0;j<n2;j++){
			scanf("%d",&B[i][j]);
		}
	}
	
	int m3,n3;
	m3=m1-m2+1;
	n3=n1-n2+1;
	
	int sum;
	
	for(i=0;i<m3;i++){
		for(j=0;j<n3;j++){
			sum=0;
			for(k=0;k<m2;k++){
				for(l=0;l<n2;l++){
					sum+=A[i+k][j+l]*B[k][l];
				}
			}
			printf("%d",sum);
			printf(" ");
		}
		printf("\n");
	}
	
	return 0;
}

