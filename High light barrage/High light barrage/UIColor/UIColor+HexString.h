//
//  UIColor+Conver.h
//  YZCommunity
//
//  Created by 曾治铭 on 15/9/2.
//  Copyright (c) 2015年 思丹元亨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)


#pragma mark —— 扩展十六进制颜色转换

/**
 *  转换十六进制颜色、默认alpha值为1
 *
 *  @param color 十六进制颜色的字符串,支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSString *)color;


/**
 *  转换十六进制颜色
 *
 *  @param color 十六进制颜色的字符串,支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @param alpha 透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;


#pragma mark —— 扩展RGB颜色转换

/**
 *  转换RGB颜色，默认alpha值为1
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue;

/**
 *  转换RGB颜色
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *  @param alpha 透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue alpha:(CGFloat)alpha;


@end
