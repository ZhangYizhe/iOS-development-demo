//
//  ViewController.m
//  DigitizerDemo
//
//  Created by 张艺哲 on 2019/7/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[self ya_zoneNumConversionWithNum: 9999]);
    NSLog(@"%@",[self ya_zoneNumConversionWithNum: 10000]);
    NSLog(@"%@",[self ya_zoneNumConversionWithNum: 99999]);
}

- (NSString *)ya_zoneNumConversionWithNum: (NSInteger) num
{
    NSString * result = [NSString stringWithFormat: @"%zd", num];
    if (num > 9999) {
        NSInteger resultNum = (NSInteger)ceil(num / 1000) * 1000;
        result = [NSString stringWithFormat:@"%.1f", (CGFloat)resultNum / 10000];
        
        if ([[result substringFromIndex: result.length - 1] isEqualToString:@"0"]) {
            result = [NSString stringWithFormat:@"%.f万", (CGFloat)resultNum / 10000];
        } else {
            result = [NSString stringWithFormat:@"%.1f万", (CGFloat)resultNum / 10000];
        }
    }
    return result;
}


@end
