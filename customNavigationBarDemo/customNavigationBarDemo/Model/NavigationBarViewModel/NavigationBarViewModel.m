//
//  NavigationBarViewModel.m
//  customNavigationBarDemo
//
//  Created by 张艺哲 on 2019/8/2.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

#import "NavigationBarViewModel.h"

@interface NavigationBarViewModel()

@property (nonatomic, strong) UIView * statusBarView;

@property (nonatomic, strong) UIView * navigationBarView;

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation NavigationBarViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _y = 0;
        _height = 44;
        _backgroundColor = [UIColor blackColor];
        _titleColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    _statusBarView.backgroundColor = _backgroundColor;
    _navigationBarView.backgroundColor = _backgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = _titleColor;
}

// 初始化Navigation Bar
- (void)initNavigationBarWithSelf: (UIViewController *) _self title : (NSString *) title hasBackBtn : (BOOL) hasBackBtn
{
    
    [_self.navigationController setNavigationBarHidden: YES animated: NO];
    
    //修复Navigation Controller侧滑关闭失效的问题
    _self.navigationController.interactivePopGestureRecognizer.delegate = (id)_self;

    // 设置Status Bar
    if (_statusBarView) [_statusBarView removeFromSuperview];
    _statusBarView = [[UIView alloc] initWithFrame: CGRectMake(0, _y, [UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    _navigationBarView.clipsToBounds = YES;
    _statusBarView.backgroundColor = _backgroundColor;
    [_self.view addSubview: _statusBarView];

    // 设置Navigation Bar
    if (_navigationBarView) [_navigationBarView removeFromSuperview];
    _navigationBarView = [[UIView alloc] initWithFrame: CGRectMake(0, _statusBarView.bounds.size.height, [UIApplication sharedApplication].statusBarFrame.size.width, _height)];
    _navigationBarView.clipsToBounds = YES;
    _navigationBarView.backgroundColor = _backgroundColor;
    [_self.view addSubview: _navigationBarView];
    
    if (_view) [_view removeFromSuperview];
    _view = [UIView new];
    _view.backgroundColor = [UIColor whiteColor];
    [_self.view addSubview:_view];
    
    _view.translatesAutoresizingMaskIntoConstraints = NO;
    [_self.view addConstraints: @[
                                  [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: _navigationBarView attribute: NSLayoutAttributeBottom multiplier:1 constant: 0],
                                  [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: _self.view attribute: NSLayoutAttributeLeft multiplier:1 constant: 0],
                                  [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: _self.view attribute: NSLayoutAttributeRight multiplier:1 constant: 0],
                                  [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: _self.view attribute: NSLayoutAttributeBottom multiplier:1 constant: 0]
                                  ]];

    

    // 标题
    if (title) {
        // 设置Navigation Bar 标题
        _self.title = title;
        _titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = _titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight: 400];
        [_navigationBarView addSubview: _titleLabel];
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(_navigationBarView.bounds.size.width / 2, _navigationBarView.bounds.size.height / 2);
    }
    
    // 返回按钮
    if (hasBackBtn) {
        UIButton * leftBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        [leftBtn addTarget: self action: @selector(backBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize: 17];
        [leftBtn setTitle:@"返回" forState: UIControlStateNormal];
        [leftBtn setTintColor: [UIColor whiteColor]];
        leftBtn.frame = CGRectMake(20, 0, 0, 0);
        [leftBtn sizeToFit];
        leftBtn.center = CGPointMake(leftBtn.center.x, _navigationBarView.bounds.size.height / 2);
        [_navigationBarView addSubview: leftBtn];
        
    }
}

- (void)backBtnTap: (UIButton *) sender
{
    if (_backBtnTapBlock) {
        _backBtnTapBlock(sender);
    }
}

@end
