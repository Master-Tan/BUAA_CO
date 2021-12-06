#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>

int n,m;

int x1,y1,x2,y2;

int A[8][8]={0};
int flag[8][8]={0};

int X=0;

void DFS(int x,int y);

int main()
{
	scanf("%d%d",&n,&m);
	int i,j;
	for(i=1;i<=n;i++){
		for(j=1;j<=m;j++){
			scanf("%d",&A[i][j]);
		}
	}
	scanf("%d%d",&x1,&y1);
	scanf("%d%d",&x2,&y2);
	
	flag[x1][y1]=1;
	DFS(x1,y1);
	
	printf("%d",X);
	return 0;	 
}

void DFS(int x,int y){
	if(x==x2&&y==y2){
		X++;
		return;
	}
	if(x!=1&&A[x-1][y]==0&&flag[x-1][y]==0){
		flag[x-1][y]=1;
		DFS(x-1,y);
		flag[x-1][y]=0;
	}
	if(x!=n&&A[x+1][y]==0&&flag[x+1][y]==0){
		flag[x+1][y]=1;
		DFS(x+1,y);
		flag[x+1][y]=0;
	}
	if(y!=1&&A[x][y-1]==0&&flag[x][y-1]==0){
		flag[x][y-1]=1;
		DFS(x,y-1);
		flag[x][y-1]=0;
	}
	if(y!=m&&A[x][y+1]==0&&flag[x][y+1]==0){
		flag[x][y+1]=1;
		DFS(x,y+1);
		flag[x][y+1]=0;
	}
	return;
}

