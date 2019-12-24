//
//  ViewController.m
//  SmsSpecialbubble
//
//  Created by 张艺哲 on 2019/12/23.
//  Copyright © 2019 Elecoxy.com. All rights reserved.
//

#import "ViewController.h"
#import "YAFightTeamMessageBubbleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EB93E7EDF398B88A7CC3A2461022A659"]];
    bgImageView.frame = self.view.frame;
    [self.view addSubview: bgImageView];
    
    YAFightTeamMessageBubbleView * fightTeamMessageBubbleView = [[YAFightTeamMessageBubbleView alloc] initWithWidth: self.view.bounds.size.width - 60 content:[[NSAttributedString alloc] initWithString:@"这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字"] type:@""];
    [fightTeamMessageBubbleView layoutIfNeeded];
    [self.view addSubview: fightTeamMessageBubbleView];
    fightTeamMessageBubbleView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
}

@end
