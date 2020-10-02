#include<iostream>
using namespace std;

class weightQuickUnion
{
private:
    int *id;
    int *sz;
public:
    weightQuickUnion(int N);
    int find(int p);
    void Union(int p, int q);
    bool connected(int p, int q);
    ~weightQuickUnion();
};

weightQuickUnion::weightQuickUnion(int N)
{
    id = new int[N];
    sz = new int[N];
    for(int i = 0; i < N; i++)
    {
        id[i] = i;
        sz[i] = 1;
    }
}

int weightQuickUnion::find(int p)
{
    while (p != id[p]){ p = id[p];}
    return p;
}

void weightQuickUnion::Union(int p, int q)
{
    int pID = find(p);
    int qID = find(q);
    if (pID == qID) return;
    if (sz[pID] < sz[qID]) { id[pID] = qID; sz[qID] += sz[pID]; }
    else{ id[qID] = pID; sz[pID] += sz[qID]; }
    // for(int i = 0; i<N; i++)
    // {
    //     cout << id[i] << endl;
    // }
}

bool weightQuickUnion::connected(int p, int q)
{
    return(find(p)==find(q));
}

weightQuickUnion::~weightQuickUnion()
{
    delete []id;
    cout << "Destructor end." << endl;
}

// int main()
// {
//     int N, p, q;
//     cout << "the number N is:" << endl;
//     cin >> N;
//     weightQuickUnion wQU(N);
//     while (true)
//     {
//         cout << "p:" << endl;
//         cin >> p;
//         cout << "q:" << endl;
//         cin >> q;
//         wQU.Union(p,q,N);
//     }
//     return 0;
// }

