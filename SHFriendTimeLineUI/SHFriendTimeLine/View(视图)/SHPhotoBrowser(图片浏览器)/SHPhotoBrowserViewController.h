//
//  SHPhotoBrowserViewController.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPhotoBrowserModel.h"

// 点击View执行的动画
typedef NS_ENUM(NSUInteger, SHPhotoBrowserAnimationAnimationStatus) {
    SHPhotoBrowserAnimationAnimationStatus_Fade = 0, // 淡入淡出
    SHPhotoBrowserAnimationAnimationStatus_Zoom, // 放大缩小
};

/**
 图片浏览器
 */
@interface SHPhotoBrowserViewController : UIViewController

// 展示的图片数组
@property (strong,nonatomic) NSArray<SHPhotoBrowserModel *> *photos;
// 当前提供的组
@property (assign,nonatomic) NSInteger currentIndex;

// 动画status (放大缩小/淡入淡出/旋转)
@property (nonatomic, assign) SHPhotoBrowserAnimationAnimationStatus status;

// @function
// 展示控制器
- (void)showPickerVc:(UIViewController *)vc;

// 展示单张图片
+ (void)showImageView:(UIImageView*)imageView originUrl:(NSString *)originUrl;

@end
