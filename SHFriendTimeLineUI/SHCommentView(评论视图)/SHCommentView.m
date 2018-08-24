//
//  SHCommentView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2018/8/23.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHCommentView.h"
#import "SHFriendTimeLineHeader.h"

@implementation SHCommentView

//获取二级评论内容
+ (NSMutableAttributedString *)getCommentWithModel:(SHFriendTimeLineComment *)model{

    NSMutableAttributedString *att;
    
    if (model.replier.length) {//存在被回复人
        att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 回复 %@：%@",model.comment,model.replier,model.content]];
    }else{
        att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",model.comment,model.content]];
    }

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    [att addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, att.length)];

    return att;
}

//刷新界面
- (void)reloadView{
    
    //移除视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    __block CGFloat view_y = self.space;
    
    [self.commentArr enumerateObjectsUsingBlock:^(SHFriendTimeLineComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        NSMutableAttributedString *att = [SHCommentView getCommentWithModel:obj];
        
        CGFloat reply_h = [att boundingRectWithSize:CGSizeMake(self.width - 2*self.margin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 2*self.space;
        
        if (!self.isCalculate) {
            
            SHClickTextView *comment = [self getComment];
            comment.frame = CGRectMake(0, view_y, self.width, reply_h);
            comment.tag = 1 + idx;
            comment.attributedText = att;
            [self addSubview:comment];
            
            //添加手势
            if (idx < self.gestArr.count) {
                [comment addGestureRecognizer:self.gestArr[idx]];
            }
            //添加链接
            [self addLinkWithComment:comment model:obj];
        }
        
        view_y += reply_h;
    }];
    
    self.height = view_y;
}

#pragma mark 获取视图
- (SHClickTextView *)getComment{
    
    SHClickTextView *comment = [[SHClickTextView alloc]init];
    comment.backgroundColor = [UIColor clearColor];
    CGFloat padding = comment.textContainer.lineFragmentPadding;
    comment.textContainerInset = UIEdgeInsetsMake(self.space, -padding + self.margin, self.space, -padding + self.margin);
    
    return comment;
}

#pragma mark 添加链接
- (void)addLinkWithComment:(SHClickTextView *)comment model:(SHFriendTimeLineComment *)model{
    
    if (!model) {
        return;
    }
    
    NSMutableArray *linkArr = [[NSMutableArray alloc]init];
        
    [linkArr addObject:@{@"parameter":model.comment,
                         @"range":[NSValue valueWithRange:NSMakeRange(0, model.comment.length)]}];
    
    if (model.replier.length) {//存在被回复人
        
        [linkArr addObject:@{@"parameter":model.replier,
                             @"range":[NSValue valueWithRange:NSMakeRange(model.comment.length + 4, model.replier.length)]}];
    }

    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:kRGB(51, 84, 135, 1)};
    //设置链接属性
    comment.linkAtts = linkAttributes;
    
    //添加参数
    comment.linkArr = linkArr;
    
    //回调
    comment.block = ^(NSString *parameter, SHClickTextView *textView) {
        if (self.block) {
            self.block(parameter, textView);
        }
    };
}

@end
