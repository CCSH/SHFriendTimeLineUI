//
//  SHPhotoBrowserModel.h
//  iOSAPP
//
//  Created by CSH on 2016/12/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHPhotoBrowserModel : NSObject

//原始图片
@property (nonatomic, copy) NSString *originUrl;
//缩略图片
@property (nonatomic, copy) NSString *thumbnailUrl;
//图片数据
@property (nonatomic, strong) id obj;
//图片
@property (nonatomic, strong) UIImage *image;

@end
