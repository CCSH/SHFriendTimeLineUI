//
//  SHTimeLineMenu.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTimeLineMenu : UIView

//初始化
+ (SHTimeLineMenu *)shareSHTimeLineMenu;

/**
 显示视图

 @param isLike 是否赞
 @param block 回调
 */
- (void)showMenuIsLike:(BOOL)isLike block:(void(^) (NSInteger type))block;

@end
