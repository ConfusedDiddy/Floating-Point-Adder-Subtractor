#include <iostream>
#include <cmath>
#include <algorithm>
#include <bitset>
#include <cstdint>

using namespace std;

int main()
{
    uint32_t x, y;
    int add_or_sub = 0;
    float fresult;

    x = 0b01010000111100111010011001001001;
    y = 0b11010000101110110110101111111010;

    float xf = *(float*)&(x);
    float yf = *(float*)&(y);
    add_or_sub = 1;

    if (add_or_sub)
        fresult = xf - yf;
    else fresult = xf + yf;
    unsigned int result = *(unsigned int*)&(fresult);

    bitset<32> binary(result);

    cout << xf << endl << yf << endl << fresult << endl;

    cout << binary << endl;
}
