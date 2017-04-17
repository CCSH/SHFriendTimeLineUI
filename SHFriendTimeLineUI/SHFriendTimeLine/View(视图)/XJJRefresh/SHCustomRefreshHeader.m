//
//  SHCustomRefreshHeader.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/17.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHCustomRefreshHeader.h"

@interface SHCustomRefreshHeader()

@property (weak, nonatomic) UIActivityIndicatorView *loading;

@property (weak, nonatomic) UIImageView *refreshView;

@end

@implementation SHCustomRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"refresh_icon.png"];
    [self addSubview:imageView];
    self.refreshView = imageView;
    
    self.clipsToBounds = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.loading.frame = self.bounds;
    self.refreshView.frame = CGRectMake(50, 100, 30, 30);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
//    CGPoint point = [change[@"new"] pointerValue];
    NSLog(@"1====%@",change);
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
//    NSLog(@"2====%@",change);
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    NSLog(@"3====%@",change);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
}


@end
