#include<iostream>
using namespace std;

class test{
    private:
        int x;
    public:
        void add(int a, int b){
            cout << a+b << endl;
        }
};

int main(){
    int a = 2;
    int b = 3;
    test func;
    func.add(a,b);
    // cout << a << endl;
}