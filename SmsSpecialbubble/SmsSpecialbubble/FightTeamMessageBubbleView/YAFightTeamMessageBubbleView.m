//
//  YAFightTeamMessageBubbleView.m
//  SmsSpecialbubble
//
//  Created by 张艺哲 on 2019/12/24.
//  Copyright © 2019 Elecoxy.com. All rights reserved.
//

#import "YAFightTeamMessageBubbleView.h"

@interface YAFightTeamMessageBubbleView()

@property (nonatomic, weak) UIFont * font;

@property (nonatomic, weak) UIColor * textColor;

@property (nonatomic, strong) NSMutableAttributedString * content;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) YYLabel * contentLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@end

@implementation YAFightTeamMessageBubbleView

/// 创建聊天气泡
/// @param width 限定宽度
/// @param content 富文本内容
/// @param type 类型
- (instancetype)initWithWidth:(CGFloat)width content: (NSAttributedString *) content type: (NSString *) type
{
    CGRect frame = CGRectMake(0, 0, width, 0);
    
    self = [super initWithFrame: frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = UIColor.whiteColor;
        
        self.content = [[NSMutableAttributedString alloc] initWithAttributedString: content];
        self.type = type;
        [self initView];
        [self reloadData];
    }
    return self;
}

// 设置字体
- (void)setFont:(UIFont *)font
{
    _font = font;
    [self reloadData];
}

// 设置字体颜色
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self reloadData];
}

- (void)initView
{
    UIImage * bgImage = [UIImage imageNamed:@"气泡"];
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 15, 10, 15); // {top, left, bottom, right};
    bgImage = [bgImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    
    _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    [self addSubview: _bgImageView];
    
    _contentLabel = [YYLabel new];
    _contentLabel.numberOfLines = 0;
    [self addSubview: _contentLabel];
}

// 设置布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 获取文字尺寸
    YYTextLayout * contentLabelTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) text: _contentLabel.attributedText];
    
    // 调整view布局
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, contentLabelTextLayout.textBoundingSize.width + 20, contentLabelTextLayout.textBoundingSize.height + 15);
    
    // 调整内容布局
    _contentLabel.frame = CGRectMake(0, 0, contentLabelTextLayout.textBoundingSize.width, contentLabelTextLayout.textBoundingSize.height);
    _contentLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // 调整背景
    _bgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

}

- (void)reloadData
{
    if (_content) {
        _content.yy_font = _font;
        _content.yy_color = _textColor;
        _content.yy_lineSpacing = 5;
    }
    _contentLabel.attributedText = _content;
    
    [self setNeedsLayout];
}

@end
