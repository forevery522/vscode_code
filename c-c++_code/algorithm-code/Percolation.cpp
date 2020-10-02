#include<iostream>
#include<cstdlib>
#include<ctime>
#include<math.h>
#include"QuickFind.h"
#include"weightQuickUnion.h"
using namespace std;

class Percolation
{
private:
    weightQuickUnion* wQU;  //采用加权quick-find算法
    bool *a;  //另定义一个数组，表示格点open或block
    int numberOpen;  //open格点的个数
    int n;
public:
    Percolation(int N);
    int numberOpensites();
    bool numberisIllegal(int i, int j);
    void open(int i, int j);
    bool isOpen(int i, int j);
    bool isFull(int i, int j);
    bool percolates();
    ~Percolation();
};

Percolation::Percolation(int N)
{
    if (N <= 0) throw "IllegalArgumentException!";
    n = N;
    numberOpen = 0;
    wQU = new weightQuickUnion(n*n+2);  //2代表创建两个虚拟格点连接顶部和底部，将二维变转换为一维
    a = new bool[n*n];
}

int Percolation::numberOpensites()
{
    return numberOpen;
}

bool Percolation::numberisIllegal(int i, int j)  //判断i，j是否合法
{
    if ( (i>0 && i<=n) && (j>0 && j<=n )){return false;} 
    return true;
}

void Percolation::open(int i, int j)
{
    if (numberisIllegal(i,j)) throw "IndexOutBoundsException!";
    if (isOpen(i,j))
    {
        return; 
    } 
    a[(i-1)*n+j-1] = 1;
    if (i == 1)
    {
        wQU->Union(0, (i-1)*n+j);
        a[(i-1)*n+j-1] = 1;
    } else if (i == n)
    {
       wQU->Union(n*n+1, (i-1)*n+j);
       a[(i-1)*n+j-1] = 1;
    }

    if(!numberisIllegal(i-1, j) && isOpen(i-1, j)) //该格点上面的格点
    {
        wQU->Union((i-1)*n+j, (i-2)*n+j);
        a[(i-1)*n+j-1] = 1;
    }
    if(!numberisIllegal(i+1, j) && isOpen(i+1, j)) //该格点下面的格点
    {
        wQU->Union(i*n+j, (i-1)*n+j);
        a[(i-1)*n+j-1] = 1;
    }
    if (!numberisIllegal(i, j-1) && isOpen(i, j-1)) //该格点左面的格点
    {
        wQU->Union((i-1)*n+j-1, (i-1)*n+j);
        a[(i-1)*n+j-1] = 1;
    }
    if (!numberisIllegal(i, j+1) && isOpen(i, j+1)) //该格点右面的格点
    {
        wQU->Union((i-1)*n+j, (i-1)*n+j+1);
        a[(i-1)*n+j-1] = 1;
    }
    numberOpen++;
}

bool Percolation::isOpen(int i, int j)
{
    if (numberisIllegal(i,j)) throw "IndexOutBoundsException!";
    return(a[(i-1) * n + j-1] == 1);
}

bool Percolation::isFull(int i, int j)
{
    if (numberisIllegal(i,j)) throw "IndexOutBoundsException!";
    return wQU->connected(((i-1) * n + j), 0);
}

bool Percolation::percolates()
{
    return wQU->connected(0, n*n+1);
}

Percolation::~Percolation(){}


class PercolationStats
{
private:
    int n;
    double *opennumber;
    double means;
    double stddevs;
    double confidencelo;
    double confidencehi;
public:
    PercolationStats(int N, int T);
    double Ratio(int N);
    double mean(int T);
    double stddev(int T);
    double confidenceLo(int T);
    double confidenceHi(int T);
    ~PercolationStats();
};

PercolationStats::PercolationStats(int N, int T)
{
    if (N<0 || T<0) throw "IllegalArgumentException!";
    n = N;
    opennumber = new double[T];
    for(int i = 0; i < T; i++)
    {
        opennumber[i] = Ratio(N);
    }
}

double PercolationStats::Ratio(int N)
{
    int i, j;
    Percolation per(N);
    srand(time(0));
    while (!per.percolates())
    {
        i = rand()%N+1;
        j = rand()%N+1;
        if (!per.isOpen(i, j)){
            per.open(i, j);
        }
    }
    // cout << per.numberOpensites() << endl;
    return ((double) per.numberOpensites()/(N*N));
}

double PercolationStats::mean(int T)
{
    double sum = 0.0;
    for (int i = 0; i < T; i++)
    {
        sum += opennumber[i];
    }
    means = (double) sum/T;
    // cout << means << endl;
    return means;
}

double PercolationStats::stddev(int T)
{
    double sum = 0;
    for (int i = 0; i < T; i++)
    {
       sum += pow(opennumber[i]-mean(T), 2); 
    }
    stddevs = (double) sqrt(sum / (T-1));
    return stddevs;
}

double PercolationStats::confidenceLo(int T)
{
    confidencelo = (double) mean(T) - 1.96*stddev(T)/sqrt(T);
    return confidencelo;
}

double PercolationStats::confidenceHi(int T)
{
    confidencehi = (double) mean(T) + 1.96*stddev(T)/sqrt(T);
    return confidencehi;
}

PercolationStats::~PercolationStats()
{
    cout << "Destructor PercolationStats end." << endl;
}

int main()
{
    int N,T;
    cout << "input the N number:" << endl;
    cin >> N;
    cout << "input the T number:" << endl;
    cin >> T;
    PercolationStats pers(N, T);
    cout << "the mean:" << pers.mean(T) << endl;
    cout << "the stddev:" << pers.stddev(T) << endl;
    cout << "the confidencelo:" << pers.confidenceLo(T) << endl;
    cout << "the confidencehi:" << pers.confidenceHi(T) << endl;
    return 0;
}