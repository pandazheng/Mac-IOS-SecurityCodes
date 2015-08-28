//
//  ViewController.m
//  TestEncrypt
//
//  Created by pandazheng on 15/8/28.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

#import "ViewController.h"

#define XOR_KEY 0xBB

@interface ViewController ()

@end

@implementation ViewController

void xorString(unsigned char *str,unsigned char key)
{
    unsigned char *p = str;
    while (((*p) ^= key) != '\0') p++;
}

- (void) testFunction
{
    unsigned char str[] = {(XOR_KEY ^ 'h'),(XOR_KEY ^ 'e'),(XOR_KEY ^ 'l'),(XOR_KEY ^ 'l'),(XOR_KEY ^ 'o'),(XOR_KEY ^ '\0')};
    xorString(str, XOR_KEY);
    static unsigned char result[6];
    memcpy(result, str, 6);
    NSLog(@"%s",result);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testFunction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
