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

//控件间隔(整体内容与屏幕边缘)
#define kContentMargin 10
//头像宽高
#define kAvatarWH 55
//昵称的高度
#define kNickH 20
//图片间隔
#define kImageMargin 5
//左右间隔
#define kLRMargin 10
//上下间隔
#define kUDMargin 5

//点赞角的高度
#define kLikeAngleH 6.5

//时间、点赞、删除高度
#define kTimeAndLikeAndDeleteH 25
#define kDeleteW 40

//点赞按钮宽
#define kLikeW 25

#define WeakSelf __weak typeof(self) weakSelf = self;


//三原色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//字体
//文字字体(文本内容、点赞、评论、删除)如果需要不同的大小分开即可
#define kContentFont [UIFont systemFontOfSize:15]

//界面
#import "SHFriendTimeLineViewController.h"
//文件
#import "SHFriendTimeLineFrame.h"
#import "UIView+Extension.h"
#import "SHFriendTimeLineType.h"
#import "SHLikeAndCommentView.h"
#import "ZLPhoto.h"
