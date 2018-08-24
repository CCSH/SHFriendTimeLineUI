//
//  SHFriendTimeLineTableViewCell.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHFriendTimeLineHeader.h"
#import "SHClickTextView.h"

/**
 朋友圈内容Cell
 */
@class SHFriendTimeLineTableViewCell;

@protocol SHFriendTimeLineDelegate <NSObject>

@optional

//消息点击
- (void)messageClick:(SHFriendTimeLineTableViewCell *)cell type:(SHFriendTimeLineClickType)type;
//评论点击
- (void)messageCommentClick:(SHFriendTimeLineTableViewCell *)cell message:(SHFriendTimeLineComment *)message;
//用户点击(可以用模型)
- (void)messageUserClick:(SHFriendTimeLineTableViewCell *)cell message:(NSString *)message;
//图片点击
- (void)imageClick:(SHFriendTimeLineTableViewCell *)cell message:(SHFriendTimeLineFrame *)message index:(NSInteger)index;

@end

@interface SHFriendTimeLineTableViewCell : UITableViewCell

#pragma mark - 代理
//代理
@property (nonatomic, weak) id<SHFriendTimeLineDelegate> delegate;

#pragma mark - 属性
//内容模型
@property (nonatomic, retain) SHFriendTimeLineFrame *messageFrame;

#pragma mark - 控件
//头像
@property (nonatomic, retain) UIButton *avatarBtn;
//名字
@property (nonatomic, retain) UILabel *nickLabel;
//文本内容
@property (nonatomic, retain) UITextView *contentTextView;
//折叠
@property (nonatomic, retain) UIButton *foldBtn;
//图片
@property (nonatomic, retain) UIView *messageImageView;
//时间
@property (nonatomic, retain) UILabel *timeLabel;
//删除
@property (nonatomic, retain) UIButton *deleteBtn;
//菜单
@property (nonatomic, retain) UIButton *menuBtn;
//点赞背景
@property (nonatomic, retain) UIImageView *likeView;
//评论背景
@property (nonatomic, retain) SHCommentView *commentView;

@end
