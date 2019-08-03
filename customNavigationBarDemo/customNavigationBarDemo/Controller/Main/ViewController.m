//
//  ViewController.m
//  customNavigationBarDemo
//
//  Created by 张艺哲 on 2019/8/1.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

#import "ViewController.h"
#import "NavigationBarViewModel.h"

@interface ViewController ()

@property (nonatomic, strong ) NavigationBarViewModel * navigationBarViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self initView];
    
    

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pushBtnTap: (UIButton *) sender
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"PUSHView" bundle: nil];
    UIViewController * pushVC = [storyboard instantiateViewControllerWithIdentifier: @"PUSHView"];
    [self.navigationController pushViewController: pushVC animated: YES];
}


- (void)initView
{
    
    _navigationBarViewModel = [NavigationBarViewModel new];
    
    // 初始化Navigation Bar
    [_navigationBarViewModel initNavigationBarWithSelf: self title: @"自定义导航栏" hasBackBtn: NO];
    _navigationBarViewModel.backgroundColor = [UIColor colorWithRed: 64/255 green: 67/255 blue:66/255 alpha: 1];
    
    _navigationBarViewModel.backBtnTapBlock = ^(UIButton * _Nonnull sender) {
        
    };

    
    UIButton * pushBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [pushBtn addTarget: self action:@selector(pushBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarViewModel.view addSubview:pushBtn];
    [pushBtn setTitle:@"PUSH一个新窗口" forState:UIControlStateNormal];
    [pushBtn sizeToFit];
    pushBtn.center = CGPointMake(_navigationBarViewModel.view.center.x, _navigationBarViewModel.view.center.y - 20);
    
    UIButton * popBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [_navigationBarViewModel.view addSubview:popBtn];
    [popBtn setTitle:@"POP一个新窗口" forState:UIControlStateNormal];
    [popBtn sizeToFit];
    popBtn.center = CGPointMake(_navigationBarViewModel.view.center.x, _navigationBarViewModel.view.center.y + 20);
    
}


@end
