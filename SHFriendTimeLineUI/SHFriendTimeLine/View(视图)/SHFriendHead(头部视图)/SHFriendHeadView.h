//
//  SHFriendHeadView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/12.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHFriendHeadView;
/**
 *  头部视图点击类型
 */
typedef enum : NSUInteger {
    
    SHFriendHeadClickType_Avatar = 1,   //头像
    SHFriendHeadClickType_Background,   //背景
}SHFriendHeadClickType;

/**
 朋友圈头部视图
 */
@protocol SHFriendHeadViewDelegate <NSObject>

@optional
//点击
- (void)headClick:(SHFriendHeadView *)view ClickType:(SHFriendHeadClickType)clickType;

@end

@interface SHFriendHeadView : UIView

//代理
@property (nonatomic, weak) id<SHFriendHeadViewDelegate> delegate;
//用户名
@property (nonatomic, copy) NSString *userName;
//用户头像
@property (nonatomic, copy) NSString *userAvatar;
//背景图
@property (nonatomic, copy) NSString *backgroundUrl;

@end
