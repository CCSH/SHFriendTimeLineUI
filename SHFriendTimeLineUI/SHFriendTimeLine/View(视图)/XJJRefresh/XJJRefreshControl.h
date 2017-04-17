//
//  XJJRefreshControl.h
//  XJJRefresh
//
//  Created by GaoDun on 15/11/19.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollViewContentOffsetObserver.h"
#import "XJJRefreshHeader.h"

@interface XJJRefreshControl : NSObject <UIScrollViewContentOffsetObserverDelegate>

@property (nonatomic, strong) UIView<XJJRefreshHeader> *xjj_refreshHeader;

@end
