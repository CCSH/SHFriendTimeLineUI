//
//  SHCommentView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2018/8/23.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHFriendTimeLineComment.h"
#import "SHClickTextView.h"

/**
 评论视图
 */
@interface SHCommentView : UIView

//数据源
@property (nonatomic, strong) NSArray <SHFriendTimeLineComment *>*commentArr;
//文字整体上下间隔
@property (nonatomic, assign) CGFloat space;
//文字整体两边间隔
@property (nonatomic, assign) CGFloat margin;
//是否只计算
@property (nonatomic, assign) BOOL isCalculate;
//用户点击回调
@property (nonatomic, copy) SHClickTextBlock block;
//整条点击事件集合
@property (nonatomic, copy) NSArray <UIGestureRecognizer *>*gestArr;

//刷新界面
- (void)reloadView;

//获取评论内容
+ (NSMutableAttributedString *)getCommentWithModel:(SHFriendTimeLineComment *)model;

@end
