//
//  ViewController.m
//  High light barrage
//
//  Created by 张艺哲 on 2019/11/20.
//  Copyright © 2019 Elecoxy.com. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HexString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"进场特效（红冠）-"]];
    [bgImageView setContentMode: UIViewContentModeScaleAspectFit];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview: bgImageView];
    
    UIView * barrageView1 = [self createBarrageViewWithTitle:@"欢迎火锅进入李白的直播间！"];
    barrageView1.center = CGPointMake(barrageView1.center.x, self.view.bounds.size.height / 2);
    barrageView1.frame = CGRectMake(10, barrageView1.frame.origin.y, barrageView1.frame.size.width, barrageView1.frame.size.height);
    [self.view addSubview: barrageView1];
    
    UIView * barrageView2 = [self createBarrageViewWithTitle:@"欢迎火锅进入\n李白的直播间！"];
    barrageView2.center = CGPointMake(barrageView2.center.x, self.view.bounds.size.height / 2 + barrageView2.bounds.size.height);
    barrageView2.frame = CGRectMake(10, barrageView2.frame.origin.y, barrageView2.frame.size.width, barrageView2.frame.size.height);
    [self.view addSubview: barrageView2];
    
    
}

- (UIView *)createBarrageViewWithTitle: (NSString *) title
{
    UIView * mainView = [UIView new];
    UILabel * contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize: 13];
    contentLabel.textColor = UIColor.whiteColor;
    [self setLineSpace: 2.0f withText:title inLabel:contentLabel];
    [contentLabel sizeToFit];
    
    mainView.frame = CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 100, contentLabel.intrinsicContentSize.height + 8);
    
    contentLabel.frame = CGRectMake(mainView.bounds.size.height / 2, contentLabel.frame.origin.y, contentLabel.frame.size.width, contentLabel.frame.size.height);
    contentLabel.center = CGPointMake(contentLabel.center.x, mainView.bounds.size.height / 2);
    [mainView addSubview: contentLabel];
    
    // 渐变背景
    UIView * gradientBackgroundView = [UIView new];
    gradientBackgroundView.frame = mainView.bounds;
    gradientBackgroundView.backgroundColor = [UIColor colorWithHex:@"000000" alpha:0.6];
    // 透明渐变
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                           nil];
    [_gradLayer setColors:colors];
        //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake((1 - gradientBackgroundView.bounds.size.height / gradientBackgroundView.bounds.size.width), 0.0f)];
//    [_gradLayer setStartPoint:CGPointMake((1 - 12 / gradientBackgroundView.bounds.size.width), 0.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.f, 0.0f)];
    [_gradLayer setFrame:gradientBackgroundView.bounds];
    [gradientBackgroundView.layer setMask: _gradLayer];
    gradientBackgroundView.layer.cornerRadius = mainView.bounds.size.height / 2;
    gradientBackgroundView.layer.masksToBounds = YES;
    gradientBackgroundView.layer.borderWidth = 1;
    gradientBackgroundView.layer.borderColor = UIColor.greenColor.CGColor;
    
    // 背景中的高光
    UIImageView * highlightImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"highlight_animation_view"]];
    highlightImageView.frame = CGRectMake(0, 0, 55, mainView.bounds.size.height + 30);
    [highlightImageView setContentMode: UIViewContentModeScaleToFill];
    highlightImageView.center = CGPointMake(highlightImageView.center.x, gradientBackgroundView.bounds.size.height / 2);
    [gradientBackgroundView addSubview: highlightImageView];
    highlightImageView.layer.affineTransform = CGAffineTransformMakeTranslation(-highlightImageView.bounds.size.width, 0);
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        highlightImageView.layer.affineTransform = CGAffineTransformMakeTranslation(gradientBackgroundView.bounds.size.width + highlightImageView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    [mainView insertSubview:gradientBackgroundView atIndex:0];
    
    return mainView;
}

/**
 设置固定行间距文本

 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

@end
