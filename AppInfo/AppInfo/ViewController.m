//
//  ViewController.m
//  AppInfo
//
//  Created by pandazheng on 15/9/18.
//  Copyright © 2015年 pandazheng. All rights reserved.
//

#import "ViewController.h"
#import "sys/utsname.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSString*) Timestamp {
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    //NSString *timestamp = [NSString stringWithFormat:@"%f",timeInterval];
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long int)timeInterval];
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSLog(@"Timesstamp Date Format = %@",dd);
    return timestamp;
}

- (NSString*) OsVersion {
    NSString *OsVersion = [[UIDevice currentDevice] systemVersion];
    return OsVersion;
}

- (NSString*) DeviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *DeviceType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return DeviceType;
}

- (NSString*) Language {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *Language = [preferredLanguages objectAtIndex:0];
    return Language;
}

- (NSString*) CountryCode {
    NSLocale* CurrentLocale = [NSLocale currentLocale];
    NSString *CountryCode = [CurrentLocale objectForKey:NSLocaleCountryCode];
    return CountryCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *AppPath = NSHomeDirectory();
    NSLog(@"AppPath = %@",AppPath);
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"bundleIdentifier = %@",bundleIdentifier);
    
    NSString *CFBundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSLog(@"CFBundleName = %@",CFBundleName);
    
    NSString *CFBundleDevelopmentRegion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDevelopmentRegion"];
    NSLog(@"CFBundleDevelopmentRegion = %@",CFBundleDevelopmentRegion);
    
    NSString *DeviceName = [[UIDevice currentDevice] name];
    NSLog(@"DeviceName = %@",DeviceName);
    
    NSString *UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UUIDString = %@",UUIDString);
    
    NSString *CFBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"CFBundleVersion = %@",CFBundleVersion);
    
    NSString *Timestamp = [self Timestamp];
    NSLog(@"Timestamp Int Format = %@",Timestamp);
    
    NSString *OsVersion = [self OsVersion];
    NSLog(@"OsVersion = %@",OsVersion);
    
    NSString *DeviceType = [self DeviceType];
    NSLog(@"DeviceType = %@",DeviceType);
    
    NSString *Language = [self Language];
    NSLog(@"Language = %@",Language);
    
    NSString *CountryCode = [self CountryCode];
    NSLog(@"CountryCode = %@",CountryCode);
    
    NSDictionary *dictionaryData = [NSDictionary dictionaryWithObjectsAndKeys:Timestamp,@"timestamp",CFBundleName,@"app",bundleIdentifier,@"bundle",DeviceName,@"name",OsVersion,@"os",
                                    DeviceType,@"type",CFBundleVersion,@"version",Language,@"language",CountryCode,@"country",UUIDString,@"idfv",nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json data: %@",json);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
