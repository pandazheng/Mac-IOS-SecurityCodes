#line 1 "/Users/pandazheng/Downloads/ChangeIPhone6Plus/ChangeIPhone6Plus/ChangeIPhone6Plus.xm"




#include "substrate.h"
int (*orig_sysctlbyname)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
int my_sysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen){

    if (strcmp(name, "hw.machine") == 0) {

        int ret = orig_sysctlbyname(name, oldp, oldlenp, newp, newlen);

        if (oldp != NULL) {

            NSLog(@"+++\n+++\n+++\n+++\n+++:before %s +++\n+++\n+++\n++++",(char*)oldp);

            const char *mechine1 = "iPhone7,1";

            strncpy((char*)oldp, mechine1, strlen(mechine1));

            NSLog(@"+++\n+++\n+++\n+++\n+++:after  %s +++\n+++\n+++\n++++",(char*)oldp);
        }

        return ret;

    }else{
        return orig_sysctlbyname(name, oldp, oldlenp, newp, newlen);
    }
}


static __attribute__((constructor)) void _logosLocalCtor_eb769390() {
    MSHookFunction((void *)MSFindSymbol(NULL,"_sysctlbyname"), (void *)my_sysctlbyname, (void **)&orig_sysctlbyname);
}
