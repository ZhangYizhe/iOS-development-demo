//
//  NavigationBarViewModel.h
//  customNavigationBarDemo
//
//  Created by 张艺哲 on 2019/8/2.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationBarViewModel : NSObject

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIView * view;

@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) UIColor * backgroundColor;

// 初始化Navigation Bar
- (void)initNavigationBarWithSelf: (UIViewController *) _self title : (NSString *) title hasBackBtn : (BOOL) hasBackBtn;


@property (nonatomic, copy) void(^backBtnTapBlock)(UIButton *);


@end

NS_ASSUME_NONNULL_END
