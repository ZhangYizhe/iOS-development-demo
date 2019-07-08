//
//  MainView.m
//  oc.masonry.demo
//
//  Created by 张艺哲 on 2019/7/8.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import "MainView.h"
#import "Masonry.h"

@interface MainView()

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, assign) CGSize btnSize;

@property (nonatomic, strong) UIButton *setBtn;

@end

@implementation MainView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _btnSize = CGSizeMake(100, 100);
        [self createView];
    }
    return self;
}

/**
 重写setter方法

 @param btnSize 尺寸
 */
- (void)setBtnSize:(CGSize)btnSize
{
    _btnSize = btnSize;
    [self setNeedsLayout];
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _testView.frame = CGRectMake(0, 0, _btnSize.width, _btnSize.height);
    _testView.center = self.center;
    
}

- (void)createView
{
    _testView = [[UIView alloc] init];
    [self addSubview: _testView];
    _testView.backgroundColor = [UIColor redColor];
    
    
    _setBtn = [[UIButton alloc] init];
    [_setBtn addTarget:self action:@selector(setBtnTap:) forControlEvents: UIControlEventTouchUpInside];
    [_setBtn setTitle:@"修改布局" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self addSubview: _setBtn];
    
    [_setBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.top).offset(40 + self.safeAreaInsets.top);
    }];
    
}

- (void)setBtnTap:(UIButton *)sender
{
    if (_btnSize.width == 100) {
         [self setBtnSize:CGSizeMake(200, 200)];
    } else {
         [self setBtnSize:CGSizeMake(100, 100)];
    }
    
   
    
    
//    [UIView animateWithDuration: 0.3 delay: 0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//
//    }];
    
    [UIView animateWithDuration: 1 delay: 0 usingSpringWithDamping: 0.3 initialSpringVelocity:0.2 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    
}



@end
