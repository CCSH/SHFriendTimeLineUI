//
//  SHPhotoBrowser.m
//  iOSAPP
//
//  Created by CSH on 2016/12/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHPhotoBrowserModel.h"
#import "UIImageView+WebCache.h"
#import "ZLPhotoAssets.h"

@implementation SHPhotoBrowserModel

- (UIImage *)image{
    
    if (!_image) {

        if ([self.obj isKindOfClass:[UIImage class]]) {//图片
            
            _image = self.obj;
        }else if ([self.obj isKindOfClass:[ZLPhotoAssets class]]){//系统图片
            
            _image = [self.obj thumbImage];
        }else if ([self.obj isKindOfClass:[NSString class]]){//字符串、网址、本地地址
            //查看资源文件
            _image = [UIImage imageNamed:self.obj];
            
            if (!_image) {
                //查看本地路径
                _image = [UIImage imageWithContentsOfFile:self.obj];
            }
        }else if ([self.obj isKindOfClass:[UIImageView class]]){//视图
            UIImageView *imageView = self.obj;
            _image = imageView.image;
        }
    }
    return _image;
}

@end
