//
//  SHCGRectHelper.m
//  iOSAPP
//
//  Created by CSH on 2016/11/28.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHCGRectHelper.h"

@implementation SHCGRectHelper

- (CGRect)getViewFrameWithNum:(NSInteger )num {
    
    //行号
    int row = (int)num/self.viewCount;
    
    //列号
    int col = (int)num%self.viewCount;
    
    //x - 由列号决定
    CGFloat x = self.viewStartX + self.marginX + col * (self.viewW + self.marginX);
    
    //y - 由行号决定
    CGFloat y = self.viewStartY + self.marginY + row * (self.viewH + self.marginY);
    
    //CGFloat
    return CGRectMake(x, y, self.viewW, self.viewH);
}

@end
