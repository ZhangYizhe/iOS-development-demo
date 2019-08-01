//
//  ViewController.m
//  stringLengthDemo
//
//  Created by 张艺哲 on 2019/7/29.
//  Copyright © 2019 张艺哲. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ViewController testWithText: @"1你"];
//    [ViewController testWithText: @"123456"];
//    [ViewController testWithText: @"这15762是一段asdfsafdaf 次😂ˉˉ"];
//    [ViewController testWithText: @"这1576💰🙅‍♂️😸♋️💰🎃🤖🈶️🙅‍♂️🖐🤦‍♂️"];
    
}

+ (NSInteger) testWithText : (NSString *) text
{
    
    NSLog(@"%zd", text.length);
    
     NSLog(@"%zd", [[text dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] length]);

    return text.length;
}


@end
