#include<stdio.h>
#include<windows.h>
#include<iostream>
#include<conio.h>

#define WAIT Sleep(1000)
using namespace std;
typedef int Semaphore;

HANDLE hDriver;
HANDLE hSeller;
DWORD dwDriverId, dwDriveParam = 1;
DWORD dwSellerId, dwSellerParam = 1;
Semaphore run = 0;
Semaphore stop = 0;
Semaphore action = 1;

void P(Semaphore &s, HANDLE hT){
    s = s-1;
    if(s<0){
        SuspendThread(hT);
    }
}
void V(Semaphore &s, HANDLE hT){
    s = s+1;
    if(s<=0){
        ResumeThread(hT);
    }
}

void DriverStart(){
    P(action, hDriver);
    printf("Driver Start...\n");
    WAIT;
    V(action, hSeller);
}
void DriverRun(){
    P(action, hDriver);
    printf("Driver Run...\n");
    WAIT;
    V(action, hSeller);
}
void DriverStop(){
    P(action, hDriver);
    printf("Driver Stop...\n");
    WAIT;
    V(action, hSeller);
}

void SellerUp(){
    P(action, hSeller);
    printf("Passager Up...\n");
    WAIT;
    V(action, hDriver);
}
void SellerDown(){
    P(action, hSeller);
    printf("Passager Down...\n");
    WAIT;
    V(action, hDriver);
}
void SellerClose(){
    P(action, hSeller);
    printf("Seller Close the door...\n");
    WAIT;
    V(action, hDriver);
}
void SellerOpen(){
    P(action, hSeller);
    printf("Seller Open the door...\n");
    WAIT;
    V(action, hDriver);
}
void SellerSell(){
    P(action, hSeller);
    printf("Seller Sell tickets...\n");
    WAIT;
    V(action, hDriver);
}

DWORD WINAPI Driver(LPVOID lpParam){
    while(1){
        P(run, hDriver);
        DriverStart();
        DriverRun();
        DriverStop();
        V(stop, hSeller);
    }
    return 0;
}
DWORD WINAPI Seller(LPVOID lpParam){
    while(1){
        SellerUp();
        SellerClose();
        V(run, hDriver);
        SellerSell();
        P(stop, hSeller);
        SellerOpen();
        SellerDown();
    }
    return 0;
}

int main(){
    hDriver = CreateThread(NULL,0,Driver,&dwDriveParam,0,&dwDriverId);
    hSeller = CreateThread(NULL,0,Seller,&dwSellerParam,0,&dwSellerId);
    getchar();
    return 0;
}