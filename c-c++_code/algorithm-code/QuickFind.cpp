#include <iostream>
using namespace std;

class QuickFind
{
private:
    int *id;
public:
    QuickFind(int N){
        id = new int[N];
        for (int i = 0; i < N; i++)
        {
            id[i] = i;
        }
    }
    int find(int p){
        return id[p];
    }
    void Union(int p, int q, int N){
        int pID = find(p);
        int qID = find(q);
        if (pID == qID) return;
        int id_length = N;
        for (int i = 0; i < id_length; i++)
        {
            if(id[i] == pID) id[i] = qID;
        }
        for (int i = 0; i < id_length; i++)
        {
            cout << id[i] << endl;
        }
    }
    ~QuickFind(){
        delete []id;
        cout << "Destructor end." << endl;
    }
};

int main(){
    int N,p,q;
    cout << "N:" << endl;
    cin >> N;
    QuickFind qk(N);
    int count = N-2;
    while (count > 0)
    {   
        cout << "p:" << endl;
        cin >> p;
        cout << "q:" << endl;
        cin >> q;
        qk.Union(p,q,N);
        count--;
    }
    return 0;
}
