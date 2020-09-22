#include <iostream>
using namespace std;

void numMax(int a = 0, int b = 0, int c = 0){
    if ( a>b && a>c){
        cout << "max is:"<<a<< endl;
    }
    else if(b>a && b>c){
        cout << "max is:"<<b<< endl;
    }
    else{
        cout << "max is:"<<c<< endl;
    }
}

int main(){
    int a,b,c,num;
    cout << "How many numbers do you want to compare:";
    cin >> num;
    if (num == 2){
        cout << "please input two numbers:";
        cin >> a;
        cin >> b;
        numMax(a,b);
    }
    else if(num == 3){
        cout << "please input three numbers:";
        cin >> a;
        cin >> b;
        cin >> c;
        numMax(a,b,c);
    }
    return 0;
}

