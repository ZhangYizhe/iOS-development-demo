//
//  BlockEmitterAnimationView.m
//  emitterLayerDemo
//
//  Created by 张艺哲 on 2019/7/17.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import "YABlockEmitterAnimationView.h"

@interface YABlockEmitterAnimationView()

@property (nonatomic, strong) CAEmitterLayer * blockEmitterLayer;

@property (nonatomic, strong) UIView * canvasView;

@end

@implementation YABlockEmitterAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _canvasView = [[UIView alloc] initWithFrame: frame];
        [self addSubview:_canvasView];
    }
    return self;
}

/**
 开始动画
 */
- (void)startAnimation
{
    if (_isShow) {
        return;
    }
    
    _isShow = YES;
    
    __weak  typeof(self) weakSelf  = self;
    
    [self initLayer];
    
    [self.blockEmitterLayer setValue:@1.f forKeyPath:@"birthRate"];
    
    // 开始动画
    self.blockEmitterLayer.beginTime = CACurrentMediaTime();
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        
        [weakSelf.blockEmitterLayer setValue:@0.f forKeyPath:@"birthRate"]; // 停止产生新碎花
        [self.blockEmitterLayer removeAllAnimations];
        
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            [weakSelf.blockEmitterLayer removeFromSuperlayer]; // 移除碎花图层
            weakSelf.isShow = NO;
        });
    });
    
}

/**
 * 碎花
 */
- (void)initLayer{
    
    // 1. 设置CAEmitterLayer
    CAEmitterLayer * blockEmitterLayer = [CAEmitterLayer layer];
    [_canvasView.layer addSublayer:blockEmitterLayer];
    self.blockEmitterLayer = blockEmitterLayer;
    
    blockEmitterLayer.emitterShape = kCAEmitterLayerLine;  // 发射源的形状 是枚举类型
    blockEmitterLayer.emitterMode = kCAEmitterLayerOutline; // 发射模式 枚举类型
    blockEmitterLayer.emitterSize = CGSizeMake(150, 0); // 发射源的size 决定了发射源的大小
    blockEmitterLayer.emitterPosition = CGPointMake(self.bounds.size.width * 0.5, 0); // 发射源的位置
    blockEmitterLayer.birthRate = 0.f; // 每秒产生的粒子数量的系数
    
    
    blockEmitterLayer.emitterCells = @[[[self createCellWithName:@"full_screen_guard_block_emitter_cell_1"] copy],[[self createCellWithName:@"full_screen_guard_block_emitter_cell_2"] copy],[[self createCellWithName:@"full_screen_guard_block_emitter_cell_3"] copy],[[self createCellWithName:@"full_screen_guard_block_emitter_cell_4"] copy], [[self createCellWithName:@"full_screen_guard_block_emitter_cell_5"] copy]];  // 粒子添加到CAEmitterLayer上
    
}

/**
 创建粒子
 
 @param name 粒子图片名称
 @return 粒子Cell
 */
- (CAEmitterCell *) createCellWithName: (NSString *) name
{
    // 配置cell
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.contents = (id)[[UIImage imageNamed: name] CGImage];  // 粒子的内容 是CGImageRef类型的
    
    cell.birthRate = 6.f;  // 每秒产生的粒子数量
    cell.lifetime = 3.0f;  // 粒子的生命周期
    
    cell.velocity = 100.f;  // 粒子的速度
    cell.yAcceleration = 80.f; // 粒子在y方向的加速的
    
    cell.spin = 3.f; // 粒子自旋速度
    
    cell.scale = 0.6; // 粒子颗粒大小
    
    cell.emissionLongitude = -M_PI;
    cell.emissionRange = M_PI_4;
    
    return cell;
    
}


/**
 事件穿透
 
 @param point point description
 @param event event description
 @return return value description
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}


@end
