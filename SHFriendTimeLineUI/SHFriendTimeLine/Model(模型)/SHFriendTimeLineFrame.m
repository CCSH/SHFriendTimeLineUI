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

@implementation SHFriendTimeLineFrame

#pragma mark 设置数据及Frame设置
- (void)setMessage:(SHFriendTimeLine *)message{
    
    _message = message;
    
    //内容X
    CGFloat Content_X = 2*kContentMargin + kAvatarWH;
    //内容Y
    CGFloat Content_Y = kContentMargin;
    
    //内容最大宽度
    CGFloat Content_MaxW = kSHWidth - (3*kContentMargin + kAvatarWH);
    
    //1、 设置头像
    _iconF = CGRectMake(kContentMargin, Content_Y, kAvatarWH, kAvatarWH);
    
    //2、 设置昵称
    _nameF = CGRectMake(Content_X, Content_Y, Content_MaxW, kNickH);
    Content_Y += kNickH + kUDMargin;
    
    NSDictionary *contentDic = @{NSFontAttributeName:kContentFont};
    //3、 设置文本内容
    if (message.messageContent.length) {//是否存在文本内容
        
        CGSize contentSize = [message.messageContent boundingRectWithSize:CGSizeMake(Content_MaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
        
        _textF = CGRectMake(Content_X, Content_Y, Content_MaxW, contentSize.height);
        
        Content_Y += contentSize.height + kUDMargin;
    }
    
    //4、 设置图片内容
    if (message.messageImageArr.count) {//是否存在图片内容
        //计算图片大小(一排3个最多3排)
        CGFloat imageWH = (Content_MaxW - kAvatarWH - 2*kImageMargin)/3;
        
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
        CGRect frame = CGRectMake(Content_X, Content_Y, Content_MaxW , line*(kImageMargin + imageWH));
        
        [imageFArr addObject:[NSValue valueWithCGRect:frame]];
        
        _imageFArr = imageFArr;
        //需要减去多出来的图片间隔
        Content_Y = CGRectGetMaxY(frame) - kImageMargin + kUDMargin;
    }
    
    //5、 时间
    _timeF = CGRectMake(Content_X, Content_Y, Content_MaxW, kTimeAndLikeAndDeleteH);
    
    //6、 删除
    _deleteF = CGRectMake(Content_X + 100, Content_Y, kDeleteW, kTimeAndLikeAndDeleteH);
    
    //7、 点赞按钮
    _likeF = CGRectMake(kSHWidth - kLikeW - kContentMargin, Content_Y, kLikeW, kTimeAndLikeAndDeleteH);
    Content_Y += kTimeAndLikeAndDeleteH + kUDMargin;
    
    //8、 点赞列表
    if (message.likeListArr.count) {//是否有点赞人
        
        NSString *likeList = [message.likeListArr componentsJoinedByString:@"、"];
        //此空格模仿点赞按钮占位
        CGSize likeListSize = [[NSString stringWithFormat:@"图 %@",likeList] boundingRectWithSize:CGSizeMake(Content_MaxW - 2*kLRMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
        //需要加上点赞按钮的角、微调
        _likeListF = CGRectMake(Content_X, Content_Y, Content_MaxW, likeListSize.height + 2*kUDMargin + kLikeAngleH + 1);
        Content_Y += _likeListF.size.height + 1;
    }
    
    //9、 评论列表
    if (message.commentArr.count) {//是否有评论人
        
        __block CGSize commentSize = CGSizeMake(Content_MaxW - 2*kLRMargin, 0);
        
        __block NSMutableArray *comentArr = [[NSMutableArray alloc]init];
        
        [message.commentArr enumerateObjectsUsingBlock:^(SHFriendTimeLineComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *comment;
            if (obj.replier) {
                
                comment = [NSString stringWithFormat:@"%@回复%@:%@",obj.comment,obj.replier,obj.content];
            }else{
                
                comment = [NSString stringWithFormat:@"%@:%@",obj.comment,obj.content];
            }
            
            CGFloat height = [comment boundingRectWithSize:CGSizeMake(Content_MaxW - 2*kLRMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size.height;
            commentSize.height += height;
            
            CGFloat view_Y = 0;
            
            if (idx) {
                view_Y = commentSize.height - height;
            }
            
            CGRect frame = CGRectMake(kLRMargin, view_Y + kUDMargin, Content_MaxW - 2*kLRMargin, height);
            
            [comentArr addObject:[NSValue valueWithCGRect:frame]];
            
        }];
    
        //每一条的集合
        _commentFArr = comentArr;
        //整体
        _commentF = CGRectMake(Content_X, Content_Y, Content_MaxW, commentSize.height + 2*kUDMargin);
        
        Content_Y += _commentF.size.height + kUDMargin;
    }
    
    //10、 Cell高度
    _cellHeight = Content_Y + kContentMargin;
}


@end
