//
//  ViewController.m
//  emitterLayerDemo
//
//  Created by 张艺哲 on 2019/7/16.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import "ViewController.h"
#import "YABlockEmitterAnimationView/YABlockEmitterAnimationView.h"

@interface ViewController ()

@property (nonatomic, strong) YABlockEmitterAnimationView * blockEmitterAnimationView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blockEmitterAnimationView = [[YABlockEmitterAnimationView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 500)];
    _blockEmitterAnimationView.clipsToBounds = YES;
    [self.view addSubview:_blockEmitterAnimationView];
    
   
}


- (IBAction)startBtnTap:(UIButton *)sender {
    
    if (_blockEmitterAnimationView) {
        [_blockEmitterAnimationView startAnimation];
    }
}


@end
