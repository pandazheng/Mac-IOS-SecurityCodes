/*
* 修改iPhone QQ手机类型为iPhone6 Plus
* 作者：tree_fly/P.Y.G, Thanks to creantan/P.Y.G
*/
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


%ctor {
    MSHookFunction((void *)MSFindSymbol(NULL,"_sysctlbyname"), (void *)my_sysctlbyname, (void **)&orig_sysctlbyname);
}
