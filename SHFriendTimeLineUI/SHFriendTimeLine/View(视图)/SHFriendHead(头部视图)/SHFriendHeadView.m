//
//  SHFriendHeadView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/12.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHFriendHeadView.h"
#import "SHFriendTimeLineHeader.h"

@interface SHFriendHeadView ()

//名字
@property (nonatomic, strong) UILabel *nameLabel;
//头像
@property (nonatomic, strong) UIImageView *avatarImageView;
//背景
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation SHFriendHeadView

#pragma mark - 懒加载
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.backgroundImageView.height - 40, self.backgroundImageView.width - 80 - 3*15, 30)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.backgroundImageView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.backgroundImageView.width - 15 - 80, self.backgroundImageView.height - 60, 80, 80)];
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 2;
        [self.backgroundImageView addSubview:_avatarImageView];
        
        _avatarImageView.tag = 1;
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClick:)]];
    }
    return _avatarImageView;
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        [self addSubview:_backgroundImageView];
        
        _backgroundImageView.tag = 2;
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClick:)]];
    }
    return _backgroundImageView;
}

#pragma mark - SET
- (void)setUserName:(NSString *)userName{
    _userName = userName;
    self.nameLabel.text = userName;
}

- (void)setUserAvatar:(NSString *)userAvatar{
    _userAvatar = userAvatar;
    self.avatarImageView.image = [UIImage imageNamed:userAvatar];
}

- (void)setBackgroundUrl:(NSString *)backgroundUrl{
    _backgroundUrl = backgroundUrl;
    self.backgroundImageView.image = [UIImage imageNamed:backgroundUrl];
}

#pragma mark - 点击
- (void)backgroundClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(headClick:ClickType:)]) {

        [self.delegate headClick:self ClickType:tap.view.tag];
    }
    
}

@end
