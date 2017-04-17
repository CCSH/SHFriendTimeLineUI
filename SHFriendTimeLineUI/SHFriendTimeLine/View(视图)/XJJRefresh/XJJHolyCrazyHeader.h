//
//  XJJHolyCrayRefreshHeader.h
//  XJJRefresh
//
//  Created by ljw on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJJRefreshHeader.h"

typedef NS_ENUM(NSInteger, XJJHolyCrazyHeaderType)
{
    XJJHolyCrazyHeaderTypeDefault = 0,
    XJJHolyCrazyHeaderTypeCustom = 1,
};

@interface XJJHolyCrazyHeader : UIView <XJJRefreshHeader>

/** 刷新时调用的block */
@property (nonatomic, copy) XJJRefreshBlock refreshBlock;

/** 刷新的状态，建议不要手动修改 */
@property (nonatomic, assign) XJJRefreshState refreshState;

/** 起始位置，相对于scrollView顶部，不是scrollView的origin */
@property (nonatomic, assign) CGPoint startPosition;

/** 刷新时的位置，相对于scrollView顶部，不是scrollView的origin (横坐标x暂时没卵用,请设置成和startPosition.x一样) */
@property (nonatomic, assign) CGPoint refreshingPosition;

/** 刷新控件的类型 */
@property (nonatomic, assign, readonly) XJJHolyCrazyHeaderType type;

/** type为XJJHolyCrazyHeaderTypeCustom时将会使用此view */
@property (nonatomic, strong) UIView *customContentView;

/** 初始化自定义header */
+ (instancetype)holyCrazyCustomHeaderWithCustomContentView:(UIView *)contentView;

/** 初始化一个默认的header */
+ (instancetype)holyCrazyDeafaultHeaderWithIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size;

@end
