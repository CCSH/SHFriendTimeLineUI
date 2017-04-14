//
//  SHPhotoTool.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHPhotoTool : NSObject

+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImage:(UIImage *)image;
+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImageView:(UIImageView *)imageView;

@end
