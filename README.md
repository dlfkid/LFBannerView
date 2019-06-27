# LFBannerView

Flexable scrollable banners for iOS.

##Features

1. Infinity scroll, you can set the bannerView to loop when initializing it, the bannerView automatically return to first image when it scrolls to one end.

2. Auto scroll with time interval, when set **scrollTimeInterval** property's value more than 0, bannerView will scroll to next image after this interval.

3. Reversable scroll direction, normally bannerView srolls from right to left, feel free to set its **scrollFromLeftToRight** property and make it reverse the scroll direction.

4. Block based tap gesture call back, when the bannerView was tapped, it will call on a block with the index of the current page as parameter, let you customize the behavior of your app.

##Usage

1. import LFBannerView.h
2. in your view controller or view
```objc
	// initialize
    LFBannerView *bannerView = [[LFBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) Loop:YES];
    bannerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bannerView];
    // set datasource
    UIImage *testImage0 = [UIImage imageNamed:@"BannerTest0"];
    UIImage *testImage1 = [UIImage imageNamed:@"BannerTest1"];
    UIImage *testImage2 = [UIImage imageNamed:@"BannerTest2"];
    UIImage *testImage3 = [UIImage imageNamed:@"BannerTest3"];
    bannerView.bannerImages = @[testImage0, testImage1, testImage2, testImage3];
    // set auto scroll time interval
    bannerView.scrollTimeInterval = 3;
    // set tap gesture callback
    bannerView.bannerTappedHandler = ^(NSInteger index) {
        NSLog(@"Banner Index : %ld", (long)index);
    };
```

##License
**LFBannerView** is released under the MIT License. See LICENSE for details.


