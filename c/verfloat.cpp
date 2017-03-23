#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

typedef int64_t int64;
typedef int32_t int32;
typedef int16_t int16;
typedef int8_t int8;
typedef uint64_t uint64;
typedef uint32_t uint32;
typedef uint16_t uint16;
typedef uint8_t uint8;
typedef uint32_t DWORD;

/*
1.int32表示范围和机器码(补码) bin()函数用于验证补码表示形式

    int32 [-2^31,2^31-1] [-2147483648,2147483647]
    -2147483648正数部分超出31bit的表示范围,机器表示形式是-0(10000000 00000000 00000000 00000000)
    所以不能用“符号位不变、其余按照正数的二进制形式按位取反再加1”获取-2147483648的补码 

2.大头小头(大端序/小端序) big endian / little endian (以下以int32举例)

    机器数(补码)只是为了方便运算所约定的计算机底层的数字表示形式，不等同于内存布局,内存布局和大头小头相关
    dec(10)   = bin(0b00000000 00000000 00000000 00001010)    = hex(0xA)            hex是补码的十六进制
    dec(-10)  = bin(0b11111111 11111111 11111111 11111011)    = hex(0xA)
    dec(-1)   = bin(0x11111111 11111111 11111111 11111111)    = hex(0xFFFFFFFF)

    
    在big endian机器的内存布局(数字的高位部分放在低地址处、低位部分放在高地址处) membin()函数用于验证数字在内存中的形式
    dec(10)     00000000 00000000 00000000 00001010 即 00 00 00 0A
    dec(-10)    11111111 11111111 11111111 11111011 即 FF FF FF FB
    dec(-1)     11111111 11111111 11111111 11111111 即 FF FF FF FF

    在little endian机器的内存布局(数字的高位部分放在高地址处、低位部分放在低地址处)
    dec(10)     00001010 00000000 00000000 00000000 即 0A 00 00 00
    dec(-10)    11111011 11111111 11111111 11111011 即 FB FF FF FF
    dec(-1)     11111111 11111111 11111111 11111111 即 FF FF FF FF
*/

char* positive2bin(const int in, char* binstr, bool filling = true)
{  
    assert(in >= 0);
    char* out = binstr;
    char t[33];
    char* tp = t;  
    int r = in; 

    while(r >= 1) {  
        *tp++ = r%2 + 48;  
        r /= 2;  
    }
    *tp-- = '\0';
    assert(tp-t == strlen(t)-1);
    //fprintf(stderr, "Positive2bin:%12d 0b%s %dbits\n", in, t, strlen(t)); 
    if (filling) for (int i = 0; i < 32-(tp-t+1); i++) *out++ = '0';
    while (tp >= t) *out++ = *tp--; //BUG: while(*out++ = *tp--);
    *out = '\0';
    
    assert(out-binstr == strlen(binstr));
    //fprintf(stderr, "--------2bin:%12d 0b%s %dbits\n", in, binstr, strlen(binstr)); 
    return binstr;
} 

char* bin(const int in, char* binstr)
{
    if (in >= 0) return positive2bin(in, binstr);
    positive2bin(-in, binstr);
    //按位取反
    *binstr = '1';
    char* p = binstr + 1;
    while ( *p != '\0') {
        if (*p == '0') *p = '1';
        else *p = '0';
        p++;
    }
    p--;
    //fprintf(stderr, "-----reverse:%12d 0b%s %dbits\n", in, binstr, strlen(binstr));
    //+1
    while (p > binstr) {
        if (*p == '0') {
            *p = '1';
            break;
        } else {
            *p = '0';
            p--;
        }
    }
    if (p == binstr) 
        fprintf(stderr, "overflow: %d\n", in);
    return binstr;
}

char* membin(const uint32* in, char* binstr)
{
    char* bp = binstr;
    char byte[9] = {0};
    uint8* p = (uint8*)in;
    for (int i = 0; i < 4; i++, p++) {
        //printf("fetched byte %d\n", (uint32)*p);
        positive2bin(*p, byte, false);
        char* tp = byte;
        for (int i = 0; i < 8-strlen(byte); i++) *bp++ = '0';
        while (*tp != '\0') *bp++ = *tp++;
    }
    *bp = '\0';
    //fprintf(stderr, "------v2-bin:%12d 0b%s %dbits\n", in, binstr, strlen(binstr));
    return binstr;
}

//验证补码的表示形式跟内存数据存放(big/little endian)
void verf_bin()
{
    char buff[128] = {0};
    char binstr[33] = {0};
    uint32 in;

begin:
    printf("please input > ");  
    scanf("%s", buff);
    if (buff[0] == '0' && (buff[1] == 'x' || buff[1] == 'X'))
        sscanf(buff, "%x", &in);
    else
        sscanf(buff, "%d", &in);

    if (in != 0x80000000U) //-2147483648，int32的最小值
        fprintf(stderr, "positive2bin:%12d 0x%08x 0b%s bin %f\n", in, in, bin((int32)in, binstr), *(float*)&in);

    fprintf(stderr, "memory--2bin:%12d 0x%08x 0b%s mem %f\n", in, in, membin((uint32*)&in, binstr), *(float*)&in);

    goto begin;  
}

int main(int argc, char** argv)
{
    char binstr[33] = {0};

    uint32 a = 0x7f700001U;
    printf("0x%8x 0b%s %f\n", a, bin((int)a,binstr), *(float*)&a);


    //https://android.googlesource.com/platform/dalvik.git/+/f6c387128427e121477c1b32ad35cdcaa5101ba3/libcore/luni/src/main/native/java_lang_Float.c
    //java源码中把所有nan替换成同一个，这样便于做比较
    uint32 nan = 0x7fc00000;
    printf("+float标准的nan 0x%8x 0b%s %f\n", nan, bin((int)nan,binstr), *(float*)&nan);

    uint32 b = 0x7f800001U;
    printf("+float最小的nan 0x%8x 0b%s %f\n", b, bin((int)b,binstr), *(float*)&b);

    uint32 c = 0x7fffffffU;
    printf("+float最大的nan 0x%8x 0b%s %f\n", c, bin((int)c,binstr), *(float*)&c);

    uint32 d = 0xff800001U;
    printf("-float最大的nan 0x%8x 0b%s %f\n", d, bin((int)d,binstr), *(float*)&d);

    uint32 e = 0xffffffffU;
    printf("-float最小的nan 0x%8x 0b%s %f\n", e, bin((int)e,binstr), *(float*)&e);

    verf_bin();
    return 0;
}

/*
    1.NaN
        https://android.googlesource.com/platform/dalvik.git/+/f6c387128427e121477c1b32ad35cdcaa5101ba3/libcore/luni/src/main/native/java_lang_Float.c
        上述URL中NAN的判定规则：指数为无效值
        
    1.xxxx * 2^n            符号    指数(n,+/-)                         尾数(1.xxxx..)
    float(32)               1       8                                   23
                                    ...
    0x7f800001U             0       111 1111 1                          000 0000 0000 0000 0000 0001    nan
    0x7fffffffU             0       111 1111 1                          111 1111 1111 1111 1111 1111    nan
    0xff800001U             1       111 1111 1                          000 0000 0000 0000 0000 0001    nan
    0xffffffffU             1       111 1111 1                          111 1111 1111 1111 1111 1111    nan
    0x7fc00000U             0       111 1111 1                          100 0000 0000 0000 0000 0000    nan
    
    0x40000001U             0       100 0000 0                          000 0000 0000 0000 0000 0001    
    0x7f000001U             0       111 1111 0                          000 0000 0000 0000 0000 0001    
    0x00000001U             0       000 0000 0                          000 0000 0000 0000 0000 0001    -> 指数000 0000 0表示的是-127
    0x007fffffU             0       000 0000 0                          111 1111 1111 1111 1111 1111    
    0x3f800000U             0       011 1111 1                          000 0000 0000 0000 0000 0000    -> 指数011 1111 1表示的是0，尾数全零表示的是1(尾数最高位被约定省略了)
    
                                    [-2^7,2^7-1]
                                    [-128,127](转正：约定+127后存入指数区间，即，127左移一位)
                                    [-1,254]
                                    [?,1111 1110] -1怎么存？ -> 应该是舍掉了吧，指数为0(即1.xxx * 2^-127)时浮点的值已经趋近于0了
                                    
    double(64)              1       11                                  52
                                    [-2^10,2^10-1]
                                    [-1024,1023]
                                    [-1,2046](转正：约定+1023后存入指数区间，即，1023左移一位)
                                    
    0x7ff8000000000000ULL   0       111 1111 1111                       1000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
*/
