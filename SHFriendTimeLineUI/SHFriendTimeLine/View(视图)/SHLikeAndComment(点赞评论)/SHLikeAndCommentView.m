//
//  SHLikeAndCommentView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHLikeAndCommentView.h"
#import "SHFriendTimeLineHeader.h"

@interface SHLikeAndCommentView ()

//点赞按钮
@property (nonatomic, strong) UIButton *likeBtn;
//评论按钮
@property (nonatomic, strong) UIButton *commentBtn;
//分割线
@property (nonatomic, strong) UIView *line;
//回调
@property (nonatomic, copy) void(^block)(NSInteger);
//父视图
@property (nonatomic, strong) UIView *supVc;

@end

@implementation SHLikeAndCommentView

#pragma mark - 初始化
+ (SHLikeAndCommentView *)shareSHLikeAndCommentView{
    static SHLikeAndCommentView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[SHLikeAndCommentView alloc]init];
        view.backgroundColor = kRGB(69, 74, 76, 1);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.size = CGSizeMake(160, 30);
    });
    return view;
}

#pragma mark - 显示视图
- (void)showSHLikeAndCommentWithSupVc:(UIView *)supVc Frame:(CGRect)frame isLike:(BOOL)isLike Block:(void (^)(NSInteger))block{
    
    [self removeFromSuperview];
    
    self.block = block;
    self.supVc = supVc;
    
    if (isLike) {
        [self.likeBtn setTitle:@"取消" forState:0];
    }else{
        [self.likeBtn setTitle:@"赞" forState:0];
    }
    self.alpha = 0;
    self.origin = frame.origin;
    self.x -= self.width;
    self.likeBtn.frame = CGRectMake(0, 0, self.width/2, self.height);
    self.commentBtn.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    self.line.frame = CGRectMake(self.width/2 - 0.25, 0.5, 0.5, self.height-1);

    [self.supVc addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - 懒加载
- (UIButton *)likeBtn{
    
    if (!_likeBtn) {
        _likeBtn = [self creatButtonWithTitle:@"" image:@"AlbumLike" selImage:@"AlbumLike@2x" target:self selector:@selector(likeClick)];
        [self addSubview:_likeBtn];
    }
    
    return _likeBtn;
}

- (UIButton *)commentBtn{
    
    if (!_commentBtn) {
        _commentBtn = [self creatButtonWithTitle:@"评论" image:@"AlbumComment" selImage:@"AlbumComment" target:self selector:@selector(commentClick)];
        [self addSubview:_commentBtn];
    }
    
    return _commentBtn;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor whiteColor];
        [self addSubview:_line];
    }
    return _line;
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
#pragma mark 点赞点击
- (void)likeClick{
    [self removeFromSuperview];
    if (self.block) {
        self.block(1);
    }

}

#pragma mark 评论点击
- (void)commentClick{
    [self removeFromSuperview];
    if (self.block) {
        self.block(2);
    }
}



@end
