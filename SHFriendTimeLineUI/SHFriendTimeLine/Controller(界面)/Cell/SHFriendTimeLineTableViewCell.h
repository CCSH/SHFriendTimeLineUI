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

@protocol SHFriendTimeLineCellDelegate <NSObject>

@optional

//消息点击(头像、点赞、展开)
- (void)messageClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineFrame *)message ClickType:(SHFriendTimeLineClickType )clickType;

//评论点击
- (void)messageCommentClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineComment *)message;
//用户点击(可以用模型)
- (void)messageUserClick:(SHFriendTimeLineTableViewCell *)cell Message:(NSString *)message;

//图片点击
- (void)imageClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineFrame *)message Index:(NSInteger)index;

@end

@interface SHFriendTimeLineTableViewCell : UITableViewCell

#pragma mark - 代理
//代理
@property (nonatomic, weak) id<SHFriendTimeLineCellDelegate> delegate;

#pragma mark - 属性
//内容模型
@property (nonatomic, retain) SHFriendTimeLineFrame *messageFrame;

#pragma mark - 控件
#pragma mark
//头像
@property (nonatomic, retain) UIButton *avatarBtn;
#pragma mark
//名字
@property (nonatomic, retain) UILabel *nickLabel;
#pragma mark
//文本内容
@property (nonatomic, retain) UITextView *contentTextView;
//展开合并
@property (nonatomic, retain) UIButton *openBtn;
#pragma mark
//图片
@property (nonatomic, retain) UIView *messageImageView;
#pragma mark
//时间
@property (nonatomic, retain) UILabel *timeLabel;
#pragma mark
//点赞、评论
@property (nonatomic, retain) UIButton *likeBtn;
#pragma mark
//点赞背景
@property (nonatomic, retain) UIImageView *likeBGView;
//点赞列表
@property (nonatomic, strong) NSArray <SHClickTextView *>*likeViewArr;
#pragma mark
//评论背景
@property (nonatomic, retain) UIImageView *commentBGView;
//评论列表
@property (nonatomic, strong) NSArray <SHClickTextView *>*commentViewArr;


@end
