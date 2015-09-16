//
//  main.c
//  find_rwx
//
//  Created by pandazheng on 15/9/16.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

#include <stdio.h>
#include "mach/task.h"

unsigned int find_rwx(){
    task_t task = mach_task_self();
    mach_vm_address_t address = 1;
    
    kern_return_t kret;
    vm_region_basic_info_data_64_t info;
    mach_vm_address_t prev_address = 0;
    mach_vm_size_t size, prev_size = 0;
    
    mach_port_t object_name;
    mach_msg_type_number_t count;
    
    while ((unsigned int) address != 0){
        
        count = VM_REGION_BASIC_INFO_COUNT_64;
        kret = mach_vm_region (task, &address, &size,
                               VM_REGION_BASIC_INFO_64,
                               (vm_region_info_t) &info,
                               &count, &object_name);
        if(info.protection == 7)
            return address;
        
        //              prev_address = address;
        //            prev_size = size;
        printf("Next: %x, %x, %x\n", (unsigned int) address, (unsigned int) size, (unsigned int) address != 0);
        address += size;
        
    }
    return 0;
}


int main(){
    unsigned int x=0;
    int y = vm_allocate(mach_task_self(), &x, 1024, 1);
    vm_protect(mach_task_self(), x, 1024, 1, 7);
    vm_protect(mach_task_self(), x, 1024, 0, 7);
    
    printf("%x - %x\n", x, find_rwx());
}
