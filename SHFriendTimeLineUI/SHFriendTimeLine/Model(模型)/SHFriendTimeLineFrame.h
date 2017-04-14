//
//  SHFriendTimeLineFrame.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHFriendTimeLine.h"

/**
 朋友圈界面模型
 */
@interface SHFriendTimeLineFrame : NSObject

//头像CGRect
@property (nonatomic, assign, readonly) CGRect iconF;
//名字CGRect
@property (nonatomic, assign, readonly) CGRect nameF;
//文本内容CGRect
@property (nonatomic, assign, readonly) CGRect textF;
//图片内容CGRectArr
@property (nonatomic, copy, readonly) NSArray *imageFArr;
//时间CGRect
@property (nonatomic, assign, readonly) CGRect timeF;
//点赞按钮CGRect
@property (nonatomic, assign, readonly) CGRect likeF;
//点赞列表CGRect
@property (nonatomic, assign, readonly) CGRect likeListF;
//评论列表CGRect
@property (nonatomic, assign, readonly) CGRect commentF;
//评论内容CGRect
@property (nonatomic, copy, readonly) NSArray *commentFArr;

//内容
@property (nonatomic, strong) SHFriendTimeLine *message;

//整体Cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
