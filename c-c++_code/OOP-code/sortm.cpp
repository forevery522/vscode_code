#include <iostream>
using namespace std;

void sortm(int &a, int &b, int &c){
    if (a>b) swap(a,b);
    if (b>c) swap(b,c);
    if (a>b) swap(a,b);
}
void sortm(float &a, float &b, float &c){
    if (a>b) swap(a,b);
    if (b>c) swap(b,c);
    if (a>b) swap(a,b);
}

int main(){
    int a,b,c;
    float x,y,z;
    cout << "please input three integer numbers:";
    cin >> a >> b >> c;
    sortm(a,b,c);
    cout << "sorted number:"<<a<<" "<<b<<" "<<c<< endl;
    cout << "please input three float numbers:";
    cin >> x >> y >> z;
    sortm(x,y,z);
    cout << "sorted number:"<<x<<" "<<y<<" "<<z<< endl;
    return 0;
}