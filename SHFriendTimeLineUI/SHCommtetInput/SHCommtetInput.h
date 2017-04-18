//
//  SHCommtetInput.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/18.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

//设备物理宽度宽高
#define SHHeight ([UIScreen mainScreen].bounds.size.height)
#define SHWidth ([UIScreen mainScreen].bounds.size.width)

@interface SHCommtetInput : UIView

//提示文字
@property (nonatomic, strong) NSString *placeholder;
//提示文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;
//携带信息
@property (nonatomic, strong) id obj;

//回调
@property (nonatomic, strong) void(^block)(NSString *text , id obj);

//初始化
+ (instancetype)sharedSHCommtetInput;

//刷新View
- (void)reloadView;

//显示
- (void)showSHCommtetInput;
//隐藏
- (void)hideSHCommtetInput;

@end
