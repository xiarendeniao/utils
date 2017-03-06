#include<iostream>
#include<stdio.h>
using namespace std;

int b2i(char* s)
{
    int total = 0;
    char* start = s;
    while (*start)
    {
        if (*start == ' ') {
            start++;
            continue;
        }
        total *= 2;
        if (*start++ == '1') total += 1;
    }
    return total;
}

int main(int argc, char** argv)
{
    char* b;
    int i;
    float f;
    printf("int %d bytes, float %d bytes\n", sizeof(i), sizeof(f));

    //31bit
    b = "01111111 11111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    printf("------------------------------------------------------------\n");

    //23bit high
    b = "01111111 11111111 11111110 00000000";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //24bit high
    b = "01111111 11111111 11111111 00000000";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //25bit high
    b = "01111111 11111111 11111111 10000000";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //26bit high
    b = "01111111 11111111 11111111 11000000";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //27bit high
    b = "01111111 11111111 11111111 11100000";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    printf("------------------------------------------------------------\n");

    //23bit low
    b = "00000000 01111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f); //正常;再往下就失真

    //24bit low
    b = "00000000 11111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //25bit low
    b = "00000001 11111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //26bit low
    b = "00000011 11111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    //27bit low
    b = "00000111 11111111 11111111 11111111";
    i = b2i(b);
    f = float(i);
    printf("b %s; i %d; f %f\n", b, i, f);

    printf("------------------------------------------------------------\n");

    f = 2147483136.1234567;
    printf("2147483136.1234567 f %.10f\n", f);

    f = 2.147483136;
    i = int(f);
    printf("2.147483136 f %f\n", f);

    f = 2.12345678;
    printf("2.12345678 f %f\n", f);


    return 0;
}
