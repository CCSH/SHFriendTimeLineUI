//
//  SHPhotoBrowserScrollView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPhotoBrowserModel.h"

typedef enum : NSUInteger {
    SHPhotoBrowserImageClick_tap = 1,   //点击
    SHPhotoBrowserImageClick_long,      //长按
} SHPhotoBrowserImageClick;

@interface SHPhotoBrowserScrollView : UIScrollView

@property (nonatomic, strong) SHPhotoBrowserModel *model;

@property (nonatomic, strong) void(^block)(SHPhotoBrowserImageClick,SHPhotoBrowserScrollView *);

@end
