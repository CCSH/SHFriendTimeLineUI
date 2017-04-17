//
//  XJJHolyCrayRefreshHeader.m
//  XJJRefresh
//
//  Created by ljw on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import "XJJHolyCrazyHeader.h"
#import "UIScrollViewScrollInfo.h"

@interface XJJHolyCrazyHeader ()

@property (nonatomic, strong) UIActivityIndicatorView *defaultRefreshView;

@end

@implementation XJJHolyCrazyHeader

@synthesize type = _type;

/** 初始化自定义header */
+ (instancetype)holyCrazyCustomHeaderWithCustomContentView:(UIView *)contentView
{
    return [[self alloc] initWithCustomContentView:contentView];
}

- (instancetype)initWithCustomContentView:(UIView *)contentView
{
    self = [self initWithFrame:contentView.bounds];
    
    if (self) {
        self.type = XJJHolyCrazyHeaderTypeCustom;
        self.customContentView = contentView;
        self.customContentView.frame = self.customContentView.bounds;
    }
    
    return self;
}

/** 初始化一个默认的header */
+ (instancetype)holyCrazyDeafaultHeaderWithIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size
{
    return [[self alloc] initWithIndicatorStyle:style size:size];
}

- (instancetype)initWithIndicatorStyle:(UIActivityIndicatorViewStyle)style size:(CGSize)size
{
    self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (self) {
        self.type = XJJHolyCrazyHeaderTypeDefault;
        self.defaultRefreshView.activityIndicatorViewStyle = style;
        self.defaultRefreshView.center = CGPointMake(size.width / 2, size.height / 2);
    }
    
    return self;
}

#pragma mark - Setter & Getter
- (void)setType:(XJJHolyCrazyHeaderType)type
{
    
    _type = type;
    
    if (_type == XJJHolyCrazyHeaderTypeDefault) {
        [self addSubview:self.defaultRefreshView];
    }
    
}

- (void)setCustomContentView:(UIView *)customContentView
{
    
    _customContentView = customContentView;
    
    if (self.type == XJJHolyCrazyHeaderTypeDefault) {
        return;
    }
    
    [self addSubview:customContentView];
    
}

- (UIActivityIndicatorView *)defaultRefreshView
{
    if (!_defaultRefreshView) {
        _defaultRefreshView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _defaultRefreshView.hidesWhenStopped = NO;
        _defaultRefreshView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _defaultRefreshView;
}

- (void)setRefreshState:(XJJRefreshState)refreshState
{
    
    if (_refreshState == refreshState) {
        return;
    }
    
    _refreshState = refreshState;
    
    switch (_refreshState) {
        case XJJRefreshStateIdle:
        {
            [self stopRefreshAnimating];
        }
            break;
        case XJJRefreshStateRefreshing:
        {
            [self startRefreshAnimating];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - XJJRefreshHeader
- (void)didUpdateWithScrollInfo:(UIScrollViewScrollInfo *)info
{
    
    if (self.refreshState != XJJRefreshStateRefreshing) {
        CGFloat angle = info.contentOffsetSection.y * 5 / 360 * 2 * M_PI;
        angle = info.scrollDirection == UIScrollViewScrollDirectionToBottom ? - angle : angle;
        
        UIView *refreshView = nil;
        
        switch (self.type) {
            case XJJHolyCrazyHeaderTypeDefault:
            {
                refreshView = self.defaultRefreshView;
            }
                break;
            case XJJHolyCrazyHeaderTypeCustom:
            {
                refreshView = self.customContentView;
            }
                break;
            default:
                break;
        }
        
        refreshView.transform = CGAffineTransformRotate(refreshView.transform, angle);
        
    }

}

- (void)startRefreshAnimating
{
    switch (self.type) {
        case XJJHolyCrazyHeaderTypeCustom:
        {
            [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
                self.customContentView.transform = CGAffineTransformRotate(self.customContentView.transform, M_PI);
            } completion:^(BOOL finished) {
            }];

        }
            break;
        case XJJHolyCrazyHeaderTypeDefault:
        {
            [self.defaultRefreshView startAnimating];
        }
            break;
            
        default:
            break;
    }
}

- (void)stopRefreshAnimating
{
    switch (self.type) {
        case XJJHolyCrazyHeaderTypeCustom:
        {
            self.customContentView.transform = CGAffineTransformMakeRotation(0.f);
            [self.customContentView.layer removeAllAnimations];
        }
            break;
        case XJJHolyCrazyHeaderTypeDefault:
        {
            [self.defaultRefreshView stopAnimating];
        }
            break;
            
        default:
            break;
    }

}

@end
