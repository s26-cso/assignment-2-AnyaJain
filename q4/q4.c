//dynamic loading!

#include <stdio.h>
#include <dlfcn.h>

typedef int (*fptr)(int, int);

int main(){
    char opname[6];
    int num1, num2;
    
    while (scanf("%s %d %d", opname, &num1, &num2)==3){
        char libname[16];
        snprintf(libname, sizeof(libname), "./lib%s.so", opname);
        void* handle = dlopen(libname, RTLD_LAZY);
        fptr op = dlsym(handle, opname);
        int result = op(num1, num2);
        dlclose(handle);
        printf("%d\n", result);
    }

    return 0;

}