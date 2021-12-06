#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
int main()
{
	int m,n;
	scanf("%d%d",&n,&m);
	int K[7500];
	int a;
	int cnt=0;
	int i=0,j=0;
	
	for(i=1;i<=n;i++){
		for(j=1;j<=m;j++){
			scanf("%d",&a);
			if(a!=0){
				K[cnt++]=i;
				K[cnt++]=j;
				K[cnt++]=a;
			}
		}
	}
	i=cnt;
	while(i>0){
		printf("%d %d %d\n",K[i-3],K[i-2],K[i-1]);
		i=i-3;
	}
}

