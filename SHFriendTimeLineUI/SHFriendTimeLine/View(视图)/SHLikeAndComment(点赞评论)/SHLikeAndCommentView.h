//
//  SHLikeAndCommentView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLikeAndCommentView : UIView

//初始化
+ (SHLikeAndCommentView *)shareSHLikeAndCommentView;

/**
 显示视图

 @param frame 初始位置
 @param isLike 是否赞
 @param block 回调
 */
- (void)showSHLikeAndCommentWithSupVc:(UIView *)supVc Frame:(CGRect)frame isLike:(BOOL)isLike Block:(void(^) (NSInteger type))block;

@end
