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
#import "SHCommentView.h"

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
//折叠CGRect
@property (nonatomic, assign, readonly) CGRect flodF;
//时间CGRect
@property (nonatomic, assign, readonly) CGRect timeF;
//删除CGRect
@property (nonatomic, assign, readonly) CGRect deleteF;
//菜单按钮CGRect
@property (nonatomic, assign, readonly) CGRect menuF;
//点赞列表CGRect
@property (nonatomic, assign, readonly) CGRect likeF;
//评论列表CGRect
@property (nonatomic, assign, readonly) CGRect commentF;

//点赞内容
@property (nonatomic, copy) NSAttributedString *likeAtt;
//图片内容CGRectArr
@property (nonatomic, copy, readonly) NSArray *imageFArr;
//评论视图
@property (nonatomic, strong) SHCommentView *commentView;
//内容
@property (nonatomic, strong) SHFriendTimeLine *message;

//整体Cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
