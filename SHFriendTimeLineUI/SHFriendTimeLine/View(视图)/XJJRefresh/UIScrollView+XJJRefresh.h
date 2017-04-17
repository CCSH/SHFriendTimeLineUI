//
//  UIScrollView+XJJRefresh.h
//  XJJRefresh
//
//  Created by GaoDun on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJJRefreshHeader.h"

@interface UIScrollView (XJJRefresh)

@property (nonatomic, strong) UIView<XJJRefreshHeader> *xjj_refreshHeader;

- (void)add_xjj_refreshHeader:(UIView<XJJRefreshHeader> *)header refreshBlock:(XJJRefreshBlock)refreshBlock;

- (void)remove_xjj_refreshHeader;

- (void)end_xjj_refresh;

- (void)begin_xjj_refresh;

- (void)replace_xjj_refreshBlock:(XJJRefreshBlock)refreshBlock;

/** 设置刷新的状态，闲置和刷新中 (仅仅改变状态，并不会调用刷新block)*/
- (void)setRefreshState:(XJJRefreshState)state;

@end
