#include<stdio.h>
#include<windows.h>
#include "shareData.h"

extern int data;

DWORD processId, processParam = 1;
HANDLE tProcess;

DWORD WINAPI Process(LPVOID processParam){
    data = 100;
    printf("changed data:%d",data);
    return 0;
}

int main(){
	printf("origin data:%d\n",data);
    tProcess = CreateThread(NULL,0,Process,&processParam,0,&processId);
    getchar();
    return 0;
}