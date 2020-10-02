#include<iostream>
#include<cstdlib>
using namespace std;

int main()
{
    for(int i = 0; i < 20; i++)
    {
        cout << rand()%6+1 << endl;
    }
    return 0;
}
