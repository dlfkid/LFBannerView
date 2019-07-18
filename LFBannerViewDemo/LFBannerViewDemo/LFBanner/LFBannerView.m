//
//  LFBannerView.m
//  TCLSmartHome
//
//  Created by LeonDeng on 2019/6/3.
//  Copyright © 2019 TCLIOT. All rights reserved.
//

#import "LFBannerView.h"


@interface LFBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LFBannerView

-(instancetype)initWithFrame:(CGRect)frame Loop:(BOOL)loop {
    self = [super initWithFrame:frame];
    if (self) {
        _loop = loop;
        _bannerImages = @[[UIImage new], [UIImage new], [UIImage new]];
        _banners = @[[[UIImageView alloc] initWithImage:self.bannerImages[0]], [[UIImageView alloc] initWithImage:self.bannerImages[1]], [[UIImageView alloc] initWithImage:self.bannerImages[2]]];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = self.bannerImages.count;
        [self addSubview:self.pageControl];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedButtonAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.banners.count, 0);
    if (self.banners.count > 0) {
        [self.banners enumerateObjectsUsingBlock:^(UIImageView * _Nonnull bannerView, NSUInteger index, BOOL * _Nonnull stop) {
            bannerView.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
    self.pageControl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 10);
    [super layoutSubviews];
}

- (void)setScrollFromLeftToRight:(BOOL)scrollFromLeftToRight {
    _scrollFromLeftToRight = scrollFromLeftToRight;
    self.pageControl.currentPage = scrollFromLeftToRight ? self.pageControl.numberOfPages - 1 : 0;
}

- (void)setScrollTimeInterval:(NSInteger)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self scrollViewScroll];
    }];
}

- (void)setBannerImages:(NSArray<UIImage *> *)bannerImages {
    _bannerImages = bannerImages;
    self.pageControl.numberOfPages = bannerImages.count;
    for (UIImageView *banner in self.banners) {
        [banner removeFromSuperview];
    }
    NSMutableArray *tempbanners = [NSMutableArray array];
    [bannerImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull banner, NSUInteger index, BOOL * _Nonnull stop) {
        UIImageView *bannerView = [[UIImageView alloc] initWithImage:banner];
        bannerView.contentMode = UIViewContentModeScaleToFill;
        bannerView.userInteractionEnabled = YES;
        [tempbanners addObject:bannerView];
        [self.scrollView addSubview:bannerView];
    }];
    if (self.loop) {
        UIImageView *firstImageView = [[UIImageView alloc] initWithImage:bannerImages.lastObject];
        UIImageView *lastImageView = [[UIImageView alloc] initWithImage:bannerImages.firstObject];
        [tempbanners insertObject:firstImageView atIndex:0];
        [tempbanners addObject:lastImageView];
        [self.scrollView addSubview:firstImageView];
        [self.scrollView addSubview:lastImageView];
    }
    self.banners = tempbanners;
    [self setNeedsLayout];
}

- (void)scrollViewScroll {
    if (self.scrollTimeInterval == 0) {
        return;
    }
    NSInteger nextPage = self.scrollFromLeftToRight ? -1 : 1;
    NSInteger truePage = self.pageControl.currentPage + nextPage;
    if (self.loop) {
        if (truePage == -1) {
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.pageControl.numberOfPages - 1, 0) animated:YES];
            self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
        } else if (truePage == self.pageControl.numberOfPages) {
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
            self.pageControl.currentPage = 0;
        } else {
            self.pageControl.currentPage = truePage;
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (self.pageControl.currentPage + 1), 0) animated:YES];
        }
    } else {
        self.pageControl.currentPage = truePage;
        if (self.pageControl.currentPage == 0 || self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
            self.scrollFromLeftToRight = !self.scrollFromLeftToRight;
        }
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.pageControl.currentPage, 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.loop) {
        if (self.scrollView.contentOffset.x == 0) {
            // 已经到第一页了，这时候应该切换到最后一页
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.pageControl.numberOfPages - 1, 0) animated:NO];
            self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
        } else if (self.scrollView.contentOffset.x == (self.pageControl.numberOfPages + 1) * self.frame.size.width) {
            // 已经到最后一页了，这时候切换到第一页
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            self.pageControl.currentPage = 0;
        } else {
            CGFloat offsetX = scrollView.contentOffset.x;
            NSInteger pageNum = self.banners.count;
            CGFloat pageThreshold = self.scrollView.contentSize.width / pageNum;
            CGFloat pageMoved = offsetX / pageThreshold;
            self.pageControl.currentPage = pageMoved - 1;
        }
    } else {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger pageNum = self.banners.count;
        CGFloat pageThreshold = self.scrollView.contentSize.width / pageNum;
        CGFloat pageMoved = offsetX / pageThreshold;
        self.pageControl.currentPage = pageMoved - 1;
    }
}

- (void)setCurrentPage:(NSInteger)page WithAnimagtion:(BOOL)animation {
    if (page < self.pageControl.numberOfPages) {
        self.pageControl.currentPage = page;
        if (self.loop) {
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (page + 1), 0) animated:animation];
        } else {
            [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * page, 0) animated:animation];
        }
    }
}

- (void)tappedButtonAction:(UITapGestureRecognizer *)sender {
    !self.bannerTappedHandler ?: self.bannerTappedHandler(self.pageControl.currentPage);
}

@end
