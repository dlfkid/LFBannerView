//
//  LFBannerView.h
//  TCLSmartHome
//
//  Created by LeonDeng on 2019/6/3.
//  Copyright © 2019 TCLIOT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFBannerView : UIView


/**
 传入滚动栏的图片数组
 */
@property (nonatomic, strong) NSArray <UIImage *> *bannerImages;

/**
 自动滚动间隔，默认为0，即不会滚动。
 */
@property (nonatomic, assign) NSInteger scrollTimeInterval;

/**
 是否能够循环滚动，只能在初始化方法中指定，不能中途修改
 */
@property (nonatomic, assign, readonly) BOOL loop;

/**
 图片点击事件回调，参数是图片下标和图片对象
 */
@property (nonatomic, copy) void(^bannerTappedHandler)(NSInteger index);

/**
 图片滚动方向，默认从右向左滚动
 */
@property (nonatomic, assign) BOOL scrollFromLeftToRight;

/**
 图片ImageViews
 */
@property (nonatomic, strong) NSArray <UIImageView *> *banners;

/**
 初始化方法

 @param frame 布局
 @param loop 是否能循环滚动
 @return 滚动栏对象
 */
- (instancetype)initWithFrame:(CGRect)frame Loop:(BOOL)loop;

/// 设置当前页
/// @param page 页码
/// @param animation 是否需要动画
- (void)setCurrentPage:(NSInteger)page WithAnimagtion:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
