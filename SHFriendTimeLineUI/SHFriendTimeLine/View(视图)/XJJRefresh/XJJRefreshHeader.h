//
//  XJJRefreshHeader.h
//  XJJRefresh
//
//  Created by GaoDun on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIScrollViewScrollInfo;

typedef void (^XJJRefreshBlock)(void);

typedef NS_ENUM(NSInteger, XJJRefreshState)
{
    XJJRefreshStateIdle = 0,
    XJJRefreshStatePulling = 1,
    XJJRefreshStateRefreshing = 2,
    XJJRefreshStateWillRefresh =3,
};

@protocol XJJRefreshHeader <NSObject>

@required;

@property (nonatomic, copy) XJJRefreshBlock refreshBlock;

@property (nonatomic, assign) XJJRefreshState refreshState;

- (CGPoint)startPosition;

- (CGPoint)refreshingPosition;

@optional;
- (void)didUpdateWithScrollInfo:(UIScrollViewScrollInfo *)info;

@end
