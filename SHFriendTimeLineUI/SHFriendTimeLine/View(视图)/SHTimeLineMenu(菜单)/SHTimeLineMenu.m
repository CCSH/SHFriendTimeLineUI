//
//  SHTimeLineMenu.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHTimeLineMenu.h"
#import "SHFriendTimeLineHeader.h"

@interface SHTimeLineMenu ()

//点赞按钮
@property (nonatomic, strong) UIButton *likeBtn;
//评论按钮
@property (nonatomic, strong) UIButton *commentBtn;
//回调
@property (nonatomic, copy) void(^block)(NSInteger);

@end

@implementation SHTimeLineMenu

#pragma mark - 初始化
+ (SHTimeLineMenu *)shareSHTimeLineMenu{
    static SHTimeLineMenu *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[SHTimeLineMenu alloc]init];
        view.backgroundColor = kRGB(69, 74, 76, 1);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.size = CGSizeMake(160, 30);
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake((view.width - 1)/2, (view.height - 10)/2, 1, 10);
        line.backgroundColor = [UIColor whiteColor].CGColor;
        [view.layer addSublayer:line];
    });
    return view;
}

#pragma mark - 显示视图
- (void)showMenuIsLike:(BOOL)isLike block:(void (^)(NSInteger))block{
    
    self.block = block;
    
    if (isLike) {
        [self.likeBtn setTitle:@"取消" forState:0];
    }else{
        [self.likeBtn setTitle:@"赞" forState:0];
    }
    
    self.alpha = 0;
    self.likeBtn.tag = 1;
    self.commentBtn.tag = 2;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - 懒加载
- (UIButton *)likeBtn{
    
    if (!_likeBtn) {
        _likeBtn = [self creatButtonWithTitle:@"" image:@"timeline_content_like" selImage:@"timeline_content_like@2x" target:self selector:@selector(btnClick:)];
        _likeBtn.frame = CGRectMake(0, 0, self.width/2, self.height);
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)commentBtn{
    
    if (!_commentBtn) {
        _commentBtn = [self creatButtonWithTitle:@"评论" image:@"timeline_content_comment" selImage:@"timeline_content_comment" target:self selector:@selector(btnClick:)];
        _commentBtn.frame = CGRectMake(self.likeBtn.maxX, self.likeBtn.y, self.likeBtn.width, self.likeBtn.height);
        [self addSubview:_commentBtn];
    }
    return _commentBtn;
}

#pragma mark 创建Btn
- (UIButton *)creatButtonWithTitle:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

#pragma mark - 按钮点击
- (void)btnClick:(UIButton *)btn{
    [self removeFromSuperview];
    if (self.block) {
        self.block(btn.tag);
    }
}

@end
