//
//  UIScrollView+XJJRefresh.m
//  XJJRefresh
//
//  Created by GaoDun on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import "UIScrollView+XJJRefresh.h"
#import "XJJRefreshControl.h"
#import <objc/runtime.h>
#import "UIScrollView+ContentOffsetObserver.h"

@interface UIScrollView ()

@property (nonatomic, strong) XJJRefreshControl *xjj_refreshControl;

@end

@implementation UIScrollView (XJJRefresh)

#pragma mark - Setter & Getter
- (UIView<XJJRefreshHeader> *)xjj_refreshHeader
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXjj_refreshHeader:(UIView<XJJRefreshHeader> *)xjj_refreshHeader
{
    objc_setAssociatedObject(self, @selector(xjj_refreshHeader), xjj_refreshHeader, OBJC_ASSOCIATION_RETAIN);
}

- (XJJRefreshControl *)xjj_refreshControl
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXjj_refreshControl:(XJJRefreshControl *)xjj_refreshControl
{
    objc_setAssociatedObject(self, @selector(xjj_refreshControl), xjj_refreshControl, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Control
- (void)add_xjj_refreshHeader:(UIView<XJJRefreshHeader> *)header refreshBlock:(XJJRefreshBlock)refreshBlock
{
    if (self.xjj_refreshHeader) {
        [self remove_xjj_refreshHeader];
    }
    
    self.xjj_refreshHeader = header;
    [self.xjj_refreshHeader setRefreshBlock:refreshBlock];
    
    [self addSubview:self.xjj_refreshHeader];
    
    [self bringSubviewToFront:self.xjj_refreshHeader];
    
    [self resetRefreshFrameToPosition:self.xjj_refreshHeader.startPosition];
    
    [self addRefreshControl];
    
}

- (void)remove_xjj_refreshHeader
{
    [self.xjj_refreshHeader removeFromSuperview];
    self.xjj_refreshHeader = nil;
    [self.contentOffsetObserver removeDelegate:self.xjj_refreshControl];
}

- (void)end_xjj_refresh
{
    self.xjj_refreshHeader.refreshState = XJJRefreshStateIdle;
    
    //暂时不处理了
    //如果结束时header位置超过刷新时的位置则不移动
//    if (- self.contentOffset.y -self.contentInset.top > -self.xjj_refreshHeader.startPosition.y && self.isDragging) {
//        return;
//    }
    
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self resetRefreshFrameToPosition:self.xjj_refreshHeader.startPosition];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)begin_xjj_refresh
{
    self.xjj_refreshHeader.refreshState = XJJRefreshStateRefreshing;
    
    if (self.xjj_refreshHeader.refreshBlock) {
        self.xjj_refreshHeader.refreshBlock();
    }
    
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self resetRefreshFrameToPosition:self.xjj_refreshHeader.refreshingPosition];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)replace_xjj_refreshBlock:(XJJRefreshBlock)refreshBlock
{
    self.xjj_refreshHeader.refreshBlock = refreshBlock;
}

/** 设置刷新的状态，闲置和刷新中 (仅仅改变状态，并不会调用刷新block)*/
- (void)setRefreshState:(XJJRefreshState)state
{
    switch (state) {
        case XJJRefreshStateIdle:
        {
            self.xjj_refreshHeader.refreshState = state;
            [self resetRefreshFrameToPosition:self.xjj_refreshHeader.startPosition];
        }
            break;
        case XJJRefreshStateRefreshing:
        {
            self.xjj_refreshHeader.refreshState = state;
            [self resetRefreshFrameToPosition:self.xjj_refreshHeader.refreshingPosition];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Helper
- (void)addRefreshControl
{
    XJJRefreshControl *control = [[XJJRefreshControl alloc] init];
    control.xjj_refreshHeader = self.xjj_refreshHeader;
    self.xjj_refreshControl = control;
    [self.contentOffsetObserver addDelegate:self.xjj_refreshControl];
}

- (void)resetRefreshFrameToPosition:(CGPoint)position
{
    CGRect frame = self.xjj_refreshHeader.frame;
    frame.origin = position;
    frame.origin.y = - self.contentInset.top + position.y;
    self.xjj_refreshHeader.frame = frame;
}

@end
