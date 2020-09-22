#include <iostream>
using namespace std;
template <typename T>

T sortm(T &a, T &b, T &c){
    if (a>b) swap(a,b);
    if (b>c) swap(b,c);
    if (a>b) swap(a,b);
}

int main(){
    int a = 3, b = 2, c = 1;
    float x = 3.5, y = 2.5, z = 1.5;
    double l = 3.66, m = 5.88, n = 9.77;
    sortm(a,b,c);
    sortm(x,y,z);
    sortm(l,m,n);
    cout << a <<" "<< b <<" "<< c << endl;
    cout << x <<" "<< y <<" "<< z << endl;
    cout << l <<" "<< m <<" "<< n << endl;
    return 0;
}