//
//  ViewController.m
//  TestPlay
//
//  Created by pandazheng on 15/9/5.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,strong) AVPlayer* avPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playBtn.frame = CGRectMake(40.0f, 40.0f, 200.0f, 48.0f);
    playBtn.center = self.view.center;
    playBtn.backgroundColor = [UIColor darkGrayColor];
    [playBtn setTitle:@"Play Video" forState:UIControlStateNormal];
    [playBtn setTitle:@"Play Video" forState:UIControlStateHighlighted];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:32.0f];
    
    [playBtn addTarget:self action:@selector(onPlayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void) onPlayButtonClicked: (UIButton *) pSender {
    NSLog(@"button click......\n");
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Mac" ofType:@"mp4"];
    NSLog(@"%@",videoPath);
    self.avPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    playerLayer.frame = self.view.bounds;
    //playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:playerLayer];
    
    [self.avPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
