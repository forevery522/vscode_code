#include<stdio.h>
#include<windows.h>

#define BUF_SIZE 1025
char sz_name[] = "BothusingName";

int main(){

    HANDLE hMapFile = OpenFileMapping(FILE_MAP_ALL_ACCESS,TRUE,sz_name);
    char *pBuf = (char*) MapViewOfFile(hMapFile,FILE_MAP_ALL_ACCESS,0,0,BUF_SIZE);
	
	printf("childprocessId:%d\n",GetCurrentProcessId());

    printf("***receive***\n");
    getchar();
    printf("%s\n",pBuf);


    UnmapViewOfFile(pBuf);
    CloseHandle(hMapFile);

    return 0;
}