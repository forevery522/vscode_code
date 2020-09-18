#include<stdio.h>
#include<windows.h>

#define BUF_SIZE 1025
char sz_name[] = "BothusingName";

int main(){
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    DWORD ID = GetCurrentProcessId();
    char szInfo[BUF_SIZE] = {0};

    HANDLE hMapFile = CreateFileMapping(INVALID_HANDLE_VALUE,NULL,PAGE_READWRITE,0,BUF_SIZE,sz_name);
    char *pBuf = (char*) MapViewOfFile(hMapFile,FILE_MAP_ALL_ACCESS,0,0,BUF_SIZE);

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));
    
    printf("parent processId:%d\n",GetCurrentProcessId());
    while(1){
        printf("***input***\n");
        gets(szInfo);
        strncpy(pBuf,szInfo,BUF_SIZE-1);
        pBuf[BUF_SIZE-1] = '\0';
        if(!CreateProcess(NULL,"C:\\Users\\HP\\Desktop\\testreceive.exe",NULL,FALSE,NULL,0,NULL,NULL,&si,&pi)){
            printf("Create Process Failed");
            return -1;
        }

        WaitForSingleObject(pi.hProcess,INFINITE);
        printf("Child Complete\n");
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
    }

    UnmapViewOfFile(pBuf);
    CloseHandle(hMapFile);

    return 0;
}
    
