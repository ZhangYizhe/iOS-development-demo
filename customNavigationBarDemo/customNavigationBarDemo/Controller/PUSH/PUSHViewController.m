//
//  PUSHViewController.m
//  customNavigationBarDemo
//
//  Created by 张艺哲 on 2019/8/2.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

#import "PUSHViewController.h"

@interface PUSHViewController ()

@end

@implementation PUSHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initView
{
    self.title = @"PUSHView";
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed: 205/255 green: 117/255 blue: 84/255 alpha: 1]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
