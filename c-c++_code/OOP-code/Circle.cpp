#include <iostream>
using namespace std;

class Circle
{
private:
    float radius;
public:
    Circle(){
        radius = 0.0;
    }
    void getArea(float a){
        float area;
        radius = a;
        area = 3.14 * radius * radius;
        cout << area << endl;
    }
    ~Circle(){
        cout << "Destructor end." << endl;
    }
};

int main(){
    Circle circle;
    float a = 2.0;
    circle.getArea(a);
    return 0;
}

