//
//  SHFriendTimeLineFrame.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHFriendTimeLineFrame.h"
#import "SHFriendTimeLineHeader.h"
#import "SHCGRectHelper.h"
#import "SHCommentView.h"

@implementation SHFriendTimeLineFrame

#pragma mark 设置数据及Frame设置
- (void)setMessage:(SHFriendTimeLine *)message{
    
    _message = message;
    
    //内容X
    CGFloat content_x = 2*kMargin + kAvatarWH;
    //内容Y
    CGFloat content_y = kMargin;
    
    //内容最大宽度
    CGFloat content_maxW = kSHWidth - (3*kMargin + kAvatarWH);
    
    //1、 设置头像
    _iconF = CGRectMake(kMargin, content_y, kAvatarWH, kAvatarWH);
    
    //2、 设置昵称
    _nameF = CGRectMake(content_x, content_y, content_maxW, kNickH);
    content_y += kNickH + kMargin;
    
    NSDictionary *contentDic = @{NSFontAttributeName:kContentFont};
    //3、 设置文本内容
    if (message.messageContent.length) {//是否存在文本内容
        
        CGSize contentSize = [message.messageContent boundingRectWithSize:CGSizeMake(content_maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;

        //规定高度
        CGFloat role_h = kContentFont.lineHeight*kXontentMaxLine;
        //如果实际内容大于规定高度则展示
        if (contentSize.height > role_h) {
            
            if (message.isFold) {//展开
                _textF = CGRectMake(content_x, content_y, content_maxW, contentSize.height);
                
            }else{
                _textF = CGRectMake(content_x, content_y, content_maxW, role_h);
            }
            
            content_y += CGRectGetHeight(_textF) + kMargin;
            
            _flodF = CGRectMake(content_x, content_y, kDeleteW, kTimeAndLikeAndDeleteH);
            content_y += CGRectGetHeight(_flodF) + kMargin;
            
        }else{
            _textF = CGRectMake(content_x, content_y, content_maxW, contentSize.height);
            content_y += contentSize.height + kMargin;
        }
    }
    
    //4、 设置图片内容
    if (message.messageImageArr.count) {//是否存在图片内容
        //计算图片大小(一排3个最多3排)
        CGFloat imageWH = (content_maxW - kAvatarWH - 2*kImageMargin)/3;
        
        SHCGRectHelper *rect = [[SHCGRectHelper alloc]init];
        rect.viewW = imageWH;
        rect.viewH = imageWH;
        rect.viewCount = 3;
        rect.viewStartY = -kImageMargin;
        rect.viewStartX = -kImageMargin;
        rect.marginX = kImageMargin;
        rect.marginY = kImageMargin;
        
        //计算图片的frame
        NSMutableArray *imageFArr = [[NSMutableArray alloc]init];
        [message.messageImageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageFArr addObject:[NSValue valueWithCGRect:[rect getViewFrameWithNum:idx]]];
        }];
        
        NSInteger line = message.messageImageArr.count/3;
        if (message.messageImageArr.count%3) {
            line += 1;
        }

        //计算图片背景frame
        CGRect frame = CGRectMake(content_x, content_y, content_maxW , line*(kImageMargin + imageWH));
        
        [imageFArr addObject:[NSValue valueWithCGRect:frame]];
        
        _imageFArr = imageFArr;
        //需要减去多出来的图片间隔
        content_y = CGRectGetMaxY(frame) - kImageMargin + kMargin;
    }
    
    //5、 设置时间
    _timeF = CGRectMake(content_x, content_y, content_maxW, kTimeAndLikeAndDeleteH);
    
    //6、 设置删除
    _deleteF = CGRectMake(content_x + 100, content_y, kDeleteW, kTimeAndLikeAndDeleteH);
    
    //7、 设置菜单
    _menuF = CGRectMake(kSHWidth - kLikeW - kContentLRMargin, content_y, kLikeW, kTimeAndLikeAndDeleteH);
    content_y += kTimeAndLikeAndDeleteH + kMargin;
    
    //8、 设置点赞列表
    if (message.likeListArr.count) {//是否有点赞人
        
        NSMutableAttributedString *likeAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[message.likeListArr componentsJoinedByString:@"、"]]];
        
        //添加点赞图片
        NSTextAttachment *likeAttachment = [[NSTextAttachment alloc]init];
        likeAttachment.image = [UIImage imageNamed:@"timeline_like"];
        //位置微调
        likeAttachment.bounds = CGRectMake(0, -2, 15, 15);
        
        NSAttributedString *image = [NSAttributedString attributedStringWithAttachment:likeAttachment];
        [likeAtt insertAttributedString:image atIndex:0];
        [likeAtt addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, likeAtt.length)];
        
        _likeAtt = likeAtt;
        //计算
        CGSize likeListSize = [likeAtt boundingRectWithSize:CGSizeMake(content_maxW - 2*kContentLRMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        //需要加上点赞按钮的角、微调
        _likeF = CGRectMake(content_x, content_y, content_maxW, likeListSize.height + 2*kContentUDMargin + kLikeAngleH);
        //点赞与评论中间有条线
        content_y += _likeF.size.height + 1;
    }
    
    //9、 设置评论列表
    if (message.commentArr.count) {//是否有评论人
        
        SHCommentView *comment = [[SHCommentView alloc]init];
        comment.frame = CGRectMake(0, 0, content_maxW, 0);
        comment.isCalculate = YES;
        comment.commentArr = message.commentArr;
        comment.space = kContentUDMargin/2;
        comment.margin = kContentLRMargin;
        [comment reloadView];
        //整体
        _commentF = CGRectMake(content_x, content_y, content_maxW, comment.height);
        
        content_y += _commentF.size.height + kMargin;
    }else{
        content_y -= 1;
    }
    
    //10、 设置Cell高度
    _cellHeight = content_y + kMargin;
}

@end
