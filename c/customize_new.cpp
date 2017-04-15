#include<stdio.h>
#include <stdlib.h>

void* operator new (size_t size, const char *file,int line,const char *func, const char* arg)
{
    printf("func new %d bytes, file(%s) line(%d) func(%s) arg(%s)\n\n", size, file, line, func, arg);
    return malloc ( size ) ;
}

void* operator new (size_t size, void* p)
{
    printf("func new %d bytes, ptr(%p)\n\n", size, p);
    return p;
}

class MyClass{
public:
    void* operator new(size_t size, const char *file, int line, const char *func, const char* arg) {
        printf("MyClass:new %d bytes, file(%s) line(%d) func(%s) arg(%s)\n\n", size, file, line, func, arg);
        return malloc ( size ) ;
    }
    void* operator new(size_t size, const char *arg1, const char *arg2) {
        printf("MyClass:new %d bytes, arg1(%s), arg2(%s)\n\n", size, arg1, arg2);
        return malloc ( size ) ;
    }
    void* operator new(size_t size, void* p) {
        printf("MyClass:new %d bytes, ptr(%p)\n\n", size, p);
        return malloc ( size ) ;
    }
};

void TestFunc() {
    int* a = new int;
    delete a;

    int* b = new (__FILE__, __LINE__, __FUNCTION__,"aaa") int;
    delete b;

    char buf[100] = {0};
    int* c = new (buf) int;
    *c = 'a';
    printf("c(%d) buf(%s)\n\n", *c, buf);

    MyClass *m = new (__FILE__, __LINE__, __FUNCTION__, "abc") MyClass();
    delete m;

    MyClass *n = new ("abc","def") MyClass();
    delete n;

    MyClass *l = new (buf) MyClass();
    delete l;

    return ;
}

int main (int argc, char** argv){
    TestFunc();
    return 0;
}
