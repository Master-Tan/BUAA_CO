#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>



// ���Կ�һ�����鵱һ���µ�ջ�ã���������



int n;
int a[1000] = {0};

int main()
{
	scanf("%d", &n);
	int i,j;
	int cin,sum,max;
	a[0]=1;
	max=1;
	for(i=1;i<=n;i++){
		cin=0;
		for(j=0;j<max;j++){
			sum=a[j]*i+cin;
			a[j]=sum%10;
			cin=sum/10;
		}
		while(cin>0){
			a[j++]=cin%10;
			cin=cin/10;
			max++;
		}
	}
	j = 999;
	while(j!=0){
		if(a[j]!=0)
			break;
		j--;
	}
	for(i=j;i>=0;i--)
		printf("%d", a[i]);
		
	return 0;
}
