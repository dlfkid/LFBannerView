//
//  ViewController.m
//  LFBannerViewDemo
//
//  Created by LeonDeng on 2019/6/4.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "ViewController.h"

#import "LFBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LFBannerView";
    LFBannerView *bannerView = [[LFBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) Loop:YES];
    bannerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bannerView];
    UIImage *testImage0 = [UIImage imageNamed:@"BannerTest0"];
    UIImage *testImage1 = [UIImage imageNamed:@"BannerTest1"];
    UIImage *testImage2 = [UIImage imageNamed:@"BannerTest2"];
    UIImage *testImage3 = [UIImage imageNamed:@"BannerTest3"];
    bannerView.bannerImages = @[testImage0, testImage1, testImage2, testImage3];
    bannerView.scrollTimeInterval = 3;
    bannerView.bannerTappedHandler = ^(NSInteger index) {
        NSLog(@"Banner Index : %ld", (long)index);
    };
}


@end
