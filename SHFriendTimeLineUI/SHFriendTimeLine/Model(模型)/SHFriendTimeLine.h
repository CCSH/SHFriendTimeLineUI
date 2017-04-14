//
//  SHFriendTimeLine.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHFriendTimeLineComment.h"

/**
 朋友圈内容模型
 */
@interface SHFriendTimeLine : NSObject

//用户信息(可以是模型)
@property (nonatomic, copy) NSString *userInfo;

//头像
@property (nonatomic, copy) NSString *friendAvatar;
//显示昵称
@property (nonatomic, copy) NSString *friendNick;
//文本内容(如果图文混排可以用NSAttributedString)
@property (nonatomic, copy) NSString *messageContent;
//全文按钮(展开、收起)
@property (nonatomic, assign) BOOL isOpen;
//图片信息数组
@property (nonatomic, copy) NSArray *messageImageArr;
//发送时间
@property (nonatomic, copy) NSString *messageTime;
//点赞数组
@property (nonatomic, copy) NSArray *likeListArr;
//评论数组
@property (nonatomic, copy) NSArray <SHFriendTimeLineComment *>*commentArr;

@end
