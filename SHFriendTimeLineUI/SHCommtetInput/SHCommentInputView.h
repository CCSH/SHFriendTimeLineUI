//
//  SHCommentInputView.h
//  KeyBoard
//
//  Created by CSH on 2017/4/17.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHEmotionKeyboard.h"

@interface SHCommentInputView : UIView

//提示文字
@property (nonatomic, strong) NSString *placeholder;
//提示文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;
//携带信息
@property (nonatomic, strong) id obj;
//回调
@property (nonatomic, strong) void(^block)(NSString *text,SHCommentInputView *view);

+ (instancetype)sharedSHCommentInputView;

- (void)reloadView;

- (void)showCommentInput;

- (void)hideCommentInput;

@end
