//
//  SHFriendTimeLineHeader.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#ifndef SHFriendTimeLineHeader_h
#define SHFriendTimeLineHeader_h


#endif /* SHFriendTimeLineHeader_h */

//当前用户
#define UserName @"那啥"

//设备物理宽度宽高
#define kSHHeight ([UIScreen mainScreen].bounds.size.height)
#define kSHWidth ([UIScreen mainScreen].bounds.size.width)

//状态栏高度
#define kStatusBarH ([[UIApplication sharedApplication] statusBarFrame].size.height)

//控件间隔
#define kMargin 10
//内容左右间隔(点赞、评论)
#define kContentLRMargin 10
//内容左右间隔(点赞、评论)
#define kContentUDMargin 5
//头像宽高
#define kAvatarWH 55
//昵称的高度
#define kNickH 20
//图片间隔
#define kImageMargin 5

//点赞背景角的高度
#define kLikeAngleH 6.5

//时间、点赞、删除、展开高度
#define kTimeAndLikeAndDeleteH 25
#define kDeleteW 40

//点赞按钮宽
#define kLikeW 25

//文本内容最大行数
#define kXontentMaxLine 4

#define WeakSelf __weak typeof(self) weakSelf = self;


//三原色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//字体
//文字字体(文本内容、点赞、评论、删除)如果需要不同的大小分开即可
#define kContentFont [UIFont systemFontOfSize:16]
#define kTimeFont [UIFont systemFontOfSize:14]

//界面
#import "SHFriendTimeLineViewController.h"
//文件
#import "SHFriendTimeLineFrame.h"
#import "UIView+SHExtension.h"
#import "SHFriendTimeLineType.h"
#import "SHTimeLineMenu.h"
#import "ZLPhoto.h"
#import "SHClickTextView.h"
#import "SHCommentView.h"
