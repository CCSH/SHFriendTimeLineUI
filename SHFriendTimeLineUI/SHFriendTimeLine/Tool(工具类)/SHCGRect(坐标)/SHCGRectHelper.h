//
//  SHCGRectHelper.h
//  iOSAPP
//
//  Created by CSH on 2016/11/28.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHCGRectHelper : NSObject

//视图的宽
@property (nonatomic, assign) CGFloat viewW;
//视图的高
@property (nonatomic, assign) CGFloat viewH;
//每行个数
@property (nonatomic, assign) NSInteger viewCount;
//Y轴起始位置
@property (nonatomic, assign) CGFloat viewStartY;
//X轴起始位置
@property (nonatomic, assign) CGFloat viewStartX;
//X轴间隔
@property (nonatomic, assign) CGFloat marginX;
//Y轴间隔
@property (nonatomic, assign) CGFloat marginY;

/**
 获取坐标

 @param num 个数
 @return 坐标
 */
- (CGRect)getViewFrameWithNum:(NSInteger )num;

@end
