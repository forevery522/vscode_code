#include <iostream>
using namespace std;

class Date
{
private:
    int year;
    int month;
    int day;
public:
    Date(){
        year = 0;
        month = 0;
        day = 0;
    }
    void setDate(int a,int b,int c){
        year = a;
        month = b;
        day = c;
    }
    void showDate(){
        cout << year <<"/"<< month <<"/"<< day << endl;
    }
    ~Date(){
        cout << "Destructor end." << endl;
    }
};

int main(){
    Date date;
    int a = 2020, b = 9, c = 22;
    date.setDate(a,b,c);
    date.showDate();
    return 0;
}