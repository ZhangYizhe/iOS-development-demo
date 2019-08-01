//
//  ViewController.m
//  timeConverterDemo
//
//  Created by 张艺哲 on 2019/8/1.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [ViewController timeConverterWithInUnixTime: 1564622580]);
    NSLog(@"%@", [ViewController timeConverterWithInUnixTime: 1564546980]);
    NSLog(@"%@", [ViewController timeConverterWithInUnixTime: 1564461780]);
    NSLog(@"%@", [ViewController timeConverterWithInUnixTime: 1564396980]);
}

+ (NSString *)timeConverterWithInUnixTime: (NSInteger) inUnixTime
{
    // 计算今天的初始时间戳
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString *todayString = [NSString stringWithFormat:@"%@ 00:00:00", [dateFormatter stringFromDate: [NSDate new]]];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *tempDate = [dateFormatter dateFromString:todayString];
    NSInteger todayUnixTime = (NSInteger)[tempDate timeIntervalSince1970];
    
    // 获取当前时间的年
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate: [NSDate new]];
    NSInteger todayYear = components.year;
    
    // 获取输入日期的年
    NSDate *inDate = [NSDate dateWithTimeIntervalSince1970: inUnixTime];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:inDate];
    CGFloat inYear = components.year;
    
    if (inUnixTime > (todayUnixTime + 86400)) {
        // 明天
        dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
    }else if (inUnixTime > todayUnixTime) {
        //今天
        dateFormatter.dateFormat = @"今天 HH:mm";
    } else if (inUnixTime > todayUnixTime - 86400) {
        // 昨天
        dateFormatter.dateFormat = @"昨天 HH:mm";
    } else if (inUnixTime > todayUnixTime - 86400 * 2) {
        //前天
        dateFormatter.dateFormat = @"前天 HH:mm";
    } else {
        if (todayYear == inYear) {
            // 今天
            dateFormatter.dateFormat = @"M月d日 HH:mm";
        } else {
            // 往年
            dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
        }
    }
    return [dateFormatter stringFromDate:  [NSDate dateWithTimeIntervalSince1970: inUnixTime]];
    
}


@end
