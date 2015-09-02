//
//  ViewController.m
//  IsJailBreak
//
//  Created by pandazheng on 15/9/2.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

#import "ViewController.h"

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

#define USER_APP_PATH     @"/User/Applications/"

#define CYDIA_APP_PATH    "/Applications/Cydia.app"

const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

@interface ViewController ()

@end

@implementation ViewController

//- (BOOL)isJailBreak
//{
//    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
//            NSLog(@"The device is jail broken!");
//            return YES;
//        }
//    }
//    NSLog(@"The device is NOT jail broken!");
//    return NO;
//}

//- (BOOL)isJailBreak
//{
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
//        NSLog(@"The device is jail broken!");
//        return YES;
//    }
//    NSLog(@"The device is NOT jail broken!");
//    return NO;
//}

//- (BOOL)isJailBreak
//{
//    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
//        NSLog(@"The device is jail broken!");
//        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
//        NSLog(@"applist = %@", applist);
//        return YES;
//    }
//    NSLog(@"The device is NOT jail broken!");
//    return NO;
//}

//int checkInject()
//{
//    int ret;
//    Dl_info dylib_info;
//    int (*func_stat)(const char*, struct stat*) = stat;
//    
//    if ((ret = dladdr(func_stat, &dylib_info)) && strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
//        return 0;
//    }
//    return 1;
//}
//
//int checkCydia()
//{
//    // first ,check whether library is inject
//    struct stat stat_info;
//    
//    if (!checkInject()) {
//        if (0 == stat(CYDIA_APP_PATH, &stat_info)) {
//            return 1;
//        }
//    } else {
//        return 1;
//    }
//    return 0;
//}
//
//- (BOOL)isJailBreak
//{
//    if (checkCydia()) {
//        NSLog(@"The device is jail broken!");
//        return YES;
//    }
//    NSLog(@"The device is NOT jail broken!");
//    return NO;
//}

char* printEnv(void)
{
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
    return env;
}

- (BOOL)isJailBreak
{
    if (printEnv()) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self isJailBreak];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
