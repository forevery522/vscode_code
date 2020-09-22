#include <iostream>
using namespace std;

class Cuboid
{
private:
    float length;
    float width;
    float height;
public:
    Cuboid(){
        length = 0.0;
        width = 0.0;
        height = 0.0;
    }
    void setParameter(){
        cout << "please input the parameter:" << endl;
        cin >> length >> width >> height;
    }
    float volume(){
        float volume;
        volume = length * width * height;
        return volume;
    }
    void showVolume(){
        cout << volume() << endl;
    }
    ~Cuboid(){
        cout << "Destructor end." << endl;
    }
};

int main(){
    Cuboid cuboid1, cuboid2, cuboid3;
    cuboid1.setParameter();
    cuboid2.setParameter();
    cuboid3.setParameter();
    cuboid1.showVolume();
    cuboid2.showVolume();
    cuboid3.showVolume();
    return 0;
}
