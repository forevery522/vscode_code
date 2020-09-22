#include <iostream>
using namespace std;

void sort(int &a,int &b,int &c){
    if (a>b) swap(a,b);
    if (b>c) swap(b,c);
    if (a>b) swap(a,b);
}

int main(){
    int a,b,c;
    cout << "please input three numbers:";
    cin >> a;
    cin >> b;
    cin >> c;
    sort(a,b,c);
    cout << "sorted number:"<<a<<b<<c<< endl;
    return 0;
}