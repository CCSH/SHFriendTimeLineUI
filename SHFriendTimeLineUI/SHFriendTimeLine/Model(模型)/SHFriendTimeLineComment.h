//
//  SHFriendTimeLineComment.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/16.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 朋友圈评论模型
 */
@interface SHFriendTimeLineComment : NSObject
//评论人
@property (nonatomic, copy) NSString *comment;
//回复人
@property (nonatomic, copy) NSString *replier;
//内容
@property (nonatomic, copy) NSString *content;

@end
