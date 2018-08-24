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
    SHFriendTimeLineClickType_fold = 1, //展开收起
    SHFriendTimeLineClickType_delete,   //删除
    SHFriendTimeLineClickType_menu,     //菜单
}SHFriendTimeLineClickType;

@interface SHFriendTimeLineType : NSObject

@end
