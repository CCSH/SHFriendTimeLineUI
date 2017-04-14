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
    
    SHFriendTimeLineClickType_Open,             //展开
    SHFriendTimeLineClickType_LikeANDComment,   //点赞、评论
    SHFriendTimeLineClickType_Comment,          //点击评论内容
}SHFriendTimeLineClickType;

@interface SHFriendTimeLineType : NSObject



@end
