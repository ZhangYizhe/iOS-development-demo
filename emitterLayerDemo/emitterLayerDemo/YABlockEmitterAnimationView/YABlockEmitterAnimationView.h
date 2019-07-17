//
//  BlockEmitterAnimationView.h
//  emitterLayerDemo
//
//  Created by 张艺哲 on 2019/7/17.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YABlockEmitterAnimationView : UIView

/**
 是否在展示
 */
@property (nonatomic, assign) BOOL isShow;

/**
 开始动画
 */
- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
