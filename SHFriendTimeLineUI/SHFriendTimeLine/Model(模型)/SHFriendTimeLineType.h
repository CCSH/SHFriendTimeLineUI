//
//  SHFriendTimeLineType.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/12.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  点击类型
 */
typedef enum : NSUInteger {
    
    SHFriendTimeLineClickType_open = 1,             //展开
    SHFriendTimeLineClickType_delete,
    SHFriendTimeLineClickType_like_comment,   //点赞、评论
    SHFriendTimeLineClickType_comment,          //点击评论内容
}SHFriendTimeLineClickType;

/**
 *  界面类型
 */
typedef enum : NSUInteger {
    SHFriendTimeLineViewType_All = 1,   //所有人
    SHFriendTimeLineViewType_One,       //某个人
} SHFriendTimeLineViewType;

@interface SHFriendTimeLineType : NSObject



@end
