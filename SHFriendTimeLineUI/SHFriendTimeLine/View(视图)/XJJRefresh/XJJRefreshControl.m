
//
//  XJJRefreshControl.m
//  XJJRefresh
//
//  Created by GaoDun on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import "XJJRefreshControl.h"
#import "UIScrollView+XJJRefresh.h"

/*
 ma dan 写得乱七八糟的!!!!!!!!!
 */

@implementation XJJRefreshControl

- (void)didOffsetChangedWithScrollViewScrollInfo:(UIScrollViewScrollInfo *)info
{
    
    //把控件放到最上面
    [info.scrollingScrollView bringSubviewToFront:self.xjj_refreshHeader];
    
    //如果不在刷新，且刷新控件不在可视范围内
    if (self.xjj_refreshHeader.refreshState != XJJRefreshStateRefreshing && info.newContentOffset.y >= -info.scrollingScrollView.contentInset.top) {
        self.xjj_refreshHeader.refreshState = XJJRefreshStateIdle;
        [self.xjj_refreshHeader didUpdateWithScrollInfo:info];
        return;
    }
    
    
    CGRect frame = info.scrollingScrollView.xjj_refreshHeader.frame;
    
    UIView<XJJRefreshHeader> *refresh = info.scrollingScrollView.xjj_refreshHeader;
    
    //是否不在刷新且正在拖拽
    if (refresh.refreshState != XJJRefreshStateRefreshing && info.scrollingScrollView.isDragging) {
        
        //position是否小于刷新时的position
        if (- info.newContentOffset.y - info.scrollingScrollView.contentInset.top < refresh.refreshingPosition.y + -refresh.startPosition.y) {
            info.scrollingScrollView.xjj_refreshHeader.refreshState = XJJRefreshStatePulling;
        }
        else
        {
            info.scrollingScrollView.xjj_refreshHeader.refreshState = XJJRefreshStateWillRefresh;
        }
        
    }
    //松手后如果是即将刷新的状态则开始刷新
    else if (refresh.refreshState == XJJRefreshStateWillRefresh)
    {
        
        refresh.refreshState = XJJRefreshStateRefreshing;
        if (refresh.refreshBlock) {
            refresh.refreshBlock();
        }
    }
    
    //没在刷新 且 超过refreshingPosition
//    NSLog(@"%lf", info.scrollingScrollView.contentInset.top);
    if (refresh.refreshState != XJJRefreshStateRefreshing && (- info.newContentOffset.y - info.scrollingScrollView.contentInset.top >= refresh.refreshingPosition.y + -refresh.startPosition.y)) {
        
        //固定住position
        frame.origin.y = info.scrollingScrollView.contentOffset.y + refresh.refreshingPosition.y;
        
        refresh.frame = frame;
        
    }
    
    //在刷新 且 超过刷新的position
    if (refresh.refreshState == XJJRefreshStateRefreshing &&  info.newContentOffset.y <= - info.scrollingScrollView.contentInset.top) {
        
        //固定住position
        frame.origin.y = info.scrollingScrollView.contentOffset.y + refresh.refreshingPosition.y;
        
        refresh.frame = frame;
        
        return;
    
    }
    
    [refresh didUpdateWithScrollInfo:info];
    
}

@end
