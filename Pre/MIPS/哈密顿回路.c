#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>

void DFS(int x,int cnt);

int X=0;
int K[10][10]={0};
int flag[10]={0};
int n;

int main()
{
	int m; 
	scanf("%d%d",&n,&m);
	int i;
	
	int V1,V2;
	for(i=0;i<m;i++){
		scanf("%d%d",&V1,&V2);
		K[V1][V2]=1;
		K[V2][V1]=1;
	}
	
	DFS(1,0);
	
	printf("%d",X);
}
void DFS(int x,int cnt){
	if(x==1){
		if(cnt==n)X=1;
		if(cnt!=0)return;
	}
	
	int i;
	for(i=1;i<10;i++){
		if(K[x][i]==1&&flag[i]==0){
			flag[i]=1; 
			DFS(i,cnt+1);
			if(X==1)break;
			flag[i]=0;
		}
	}
	return;
}
