//
//  SHPublishViewController.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHFriendTimeLineHeader.h"

/**
 发布界面
 */
@interface SHPublishViewController : UIViewController

//回调
@property (nonatomic, strong) void(^block)(SHFriendTimeLine *message);


@end
