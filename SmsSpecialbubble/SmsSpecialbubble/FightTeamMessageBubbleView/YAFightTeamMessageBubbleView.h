//
//  YAFightTeamMessageBubbleView.h
//  SmsSpecialbubble
//
//  Created by 张艺哲 on 2019/12/24.
//  Copyright © 2019 Elecoxy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface YAFightTeamMessageBubbleView : UIView

/// 创建聊天气泡
/// @param width 限定宽度
/// @param content 富文本内容
/// @param type 类型
- (instancetype)initWithWidth:(CGFloat)width content: (NSAttributedString *) content type: (NSString *) type;

@end

NS_ASSUME_NONNULL_END
