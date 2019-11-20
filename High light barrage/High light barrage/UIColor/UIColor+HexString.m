//
//  UIColor+Conver.m
//  YZCommunity
//
//  Created by 曾治铭 on 15/9/2.
//  Copyright (c) 2015年 思丹元亨. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

#pragma mark —— 扩展十六进制颜色转换

/**
 *  转换十六进制颜色、默认alpha值为1
 *
 *  @param color 十六进制颜色的字符串
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSString *)color{
    return [self colorWithHex:color alpha:1.0f];
}

/**
 *  转换十六进制颜色
 *
 *  @param color 十六进制颜色的字符串
 *  @param alpha 透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha{
    
    //!< 删除字符串中的空格
    NSString *colorStr = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //!< 字符串应该是6或8个字符
    if ([colorStr length] < 6){
        return [UIColor clearColor];
    }
    
    //!< 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"0X"]){
        colorStr = [colorStr substringFromIndex:2];
    }
    
    //!< 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"#"]){
        colorStr = [colorStr substringFromIndex:1];
    }
    
    //!< 最后判断字符串是否为六位字符
    if ([colorStr length] != 6){
        return [UIColor clearColor];
    }
    
    /**
     *  分离成R、G、B子字符串
     */
    NSString *redStr = [colorStr substringWithRange:NSMakeRange(0, 2)];    //!< red字符串
    NSString *greenStr = [colorStr substringWithRange:NSMakeRange(2, 2)];    //!< green字符串
    NSString *blueStr = [colorStr substringWithRange:NSMakeRange(4, 2)];    //!< blue字符串
    
    /**
     *  将十六进制的R、G、B转换为Int
     */
    unsigned int redInt, greenInt, blueInt;
    [[NSScanner scannerWithString:redStr] scanHexInt:&redInt];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&greenInt];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&blueInt];
    
    //!< 返回颜色值
    //return [UIColor colorWithRed:(redInt / 255.0f) green:(greenInt / 255.0f) blue:(blueInt / 255.0f) alpha:alpha];
    return [UIColor colorWithRedValue:redInt greenValue:greenInt blueValue:blueInt alpha:alpha];
}

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
+ (UIColor *)colorWithRedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:1.0f];
}

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
+ (UIColor *)colorWithRedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:alpha];
}


@end

