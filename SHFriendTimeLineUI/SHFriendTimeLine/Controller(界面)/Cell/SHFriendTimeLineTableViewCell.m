//
//  SHFriendTimeLineTableViewCell.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHFriendTimeLineTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SHFriendTimeLineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - 懒加载
#pragma mark 创建头像
- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarBtn addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_avatarBtn];
    }
    return _avatarBtn;
}

#pragma mark 创建昵称
- (UILabel *)nickLabel{
    
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.textColor = kRGB(51, 84, 135, 1);
        _nickLabel.font = kContentFont;
        
        [self.contentView addSubview:_nickLabel];
    }
    return _nickLabel;
}

#pragma mark 创建文字内容
- (UITextView *)contentTextView{
    
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.textContainerInset = UIEdgeInsetsMake(0, -3, 0, -3);
        _contentTextView.font = kContentFont;
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = NO;
        _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        
        [self.contentView addSubview:_contentTextView];
    }
    return _contentTextView;
}

#pragma mark 创建展开按钮
- (UIButton *)foldBtn{
    if (!_foldBtn) {
        _foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldBtn addTarget:self action:@selector(foldClick) forControlEvents:UIControlEventTouchUpInside];
        [_foldBtn setTitleColor:kRGB(51, 84, 135, 1) forState:0];
        _foldBtn.titleLabel.font = kContentFont;
        [self.contentView addSubview:_foldBtn];
    }
    return _foldBtn;
}

#pragma mark 创建图片内容
- (UIView *)messageImageView{
    
    if (!_messageImageView) {
        _messageImageView = [[UIView alloc]init];
        [self.contentView addSubview:_messageImageView];
    }
    return _messageImageView;
}

#pragma mark 创建时间
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = kTimeFont;
        _timeLabel.textColor = kRGB(100, 100, 100, 1);
        
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

#pragma mark 创建删除
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:0];
        [_deleteBtn setTitleColor:kRGB(51, 84, 135, 1) forState:0];
        _deleteBtn.titleLabel.font = kContentFont;
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

#pragma mark 创建菜单
- (UIButton *)menuBtn{
    
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"timeline_content_menu"] forState:0];
        [_menuBtn addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_menuBtn];
    }
    return _menuBtn;
}

#pragma mark 创建点赞背景
- (UIImageView *)likeView{
    
    if (!_likeView) {
        _likeView = [[UIImageView alloc]init];
        UIImage *normal = [[UIImage imageNamed:@"timeline_like_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 30, 1, 1)];
        _likeView.image = normal;
        _likeView.userInteractionEnabled = YES;
        
        //点赞内容
        SHClickTextView *textView = [[SHClickTextView alloc]init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainerInset = UIEdgeInsetsMake(kLikeAngleH + kContentUDMargin, kContentLRMargin, 0, kContentLRMargin);
        textView.linkAtts = @{NSForegroundColorAttributeName:kRGB(51, 84, 135, 1)};
        //回调
        textView.block = ^(NSString *parameter, SHClickTextView *textView) {
            
            //点击了用户
            if ([self.delegate respondsToSelector:@selector(messageUserClick:message:)]) {
                [self.delegate messageUserClick:self message:parameter];
            }
        };
        
        [_likeView addSubview:textView];
        
        [self.contentView addSubview:_likeView];
    }
    return _likeView;
}

#pragma mark 创建评论背景
- (SHCommentView *)commentView{
    
    if (!_commentView) {
        _commentView = [[SHCommentView alloc]init];
        _commentView.backgroundColor = kRGB(240, 240, 240, 1);
        _commentView.userInteractionEnabled = YES;
        _commentView.space = kContentUDMargin/2;
        _commentView.margin = kContentLRMargin;
        
        [self.contentView addSubview:_commentView];
    }
    return _commentView;
}

#pragma mark - 点击
#pragma mark 头像点击
- (void)avatarClick{
    
    if ([self.delegate respondsToSelector:@selector(messageUserClick:message:)]) {
        [self.delegate messageUserClick:self message:self.messageFrame.message.friendNick];
    }
}

#pragma mark 折叠点击
- (void)foldClick{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:type:)]) {
        [self.delegate messageClick:self type:SHFriendTimeLineClickType_fold];
    }
}

#pragma mark 菜单点击
- (void)menuClick{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:type:)]) {
        [self.delegate messageClick:self type:SHFriendTimeLineClickType_menu];
    }
}

#pragma mark 删除点击
- (void)deleteClick{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:type:)]) {
        [self.delegate messageClick:self type:SHFriendTimeLineClickType_delete];
    }
}

#pragma mark 图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(imageClick:message:index:)]) {
        [self.delegate imageClick:self message:self.messageFrame index:tap.view.tag - 1];
    }
}

#pragma mark 评论点击
- (void)commentClick:(UITapGestureRecognizer *)gest{
    
    UIView *view = gest.view;
    
    view.backgroundColor = [UIColor lightGrayColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.backgroundColor = [UIColor clearColor];
    });
    
    if ([self.delegate respondsToSelector:@selector(messageCommentClick:message:)]) {
        [self.delegate messageCommentClick:self message:self.messageFrame.message.commentArr[gest.view.tag - 1]];
    }
}

#pragma mark - 内容及Frame设置
- (void)setMessageFrame:(SHFriendTimeLineFrame *)messageFrame{
    _messageFrame = messageFrame;
    
    SHFriendTimeLine *message = messageFrame.message;
    
    //初始化
    self.contentTextView.hidden = YES;
    self.foldBtn.hidden = YES;
    self.messageImageView.hidden = YES;
    self.likeView.hidden = YES;
    self.commentView.hidden = YES;
    self.deleteBtn.hidden = YES;
    
    //1、 设置头像
    self.avatarBtn.frame = messageFrame.iconF;
    [self.avatarBtn setBackgroundImage:[UIImage imageNamed:message.friendAvatar] forState:0];
    
    //2、 设置昵称
    self.nickLabel.frame = messageFrame.nameF;
    self.nickLabel.text = message.friendNick;
    
    //3、 设置文本内容
    if (message.messageContent.length) {//是否有文本内容
        
        [self addmessageContentView];
    }
    
    //4、 设置图片内容
    if (message.messageImageArr.count) {//是否有图片内容
        
        [self addMessageImageView];
    }
    
    //5、 时间
    self.timeLabel.frame= messageFrame.timeF;
    self.timeLabel.text = message.messageTime;
    
    //6、 删除
    self.deleteBtn.frame = messageFrame.deleteF;
    self.deleteBtn.hidden = ![messageFrame.message.friendNick isEqualToString:UserName];
    
    //7、 菜单按钮
    self.menuBtn.frame = messageFrame.menuF;
    
    //8、 点赞列表
    if (message.likeListArr.count) {//是否有点赞

        [self addMessageLikeView];
    }
    
    //9、 评论列表
    if (message.commentArr.count) {//是否有评论
        
        [self addMessageCommentView];
    }
}

#pragma mark - 添加控件
#pragma mark 文本视图
- (void)addmessageContentView{
    
    self.contentTextView.hidden = NO;
    self.contentTextView.frame = self.messageFrame.textF;
    self.contentTextView.text = self.messageFrame.message.messageContent;
    
    //折叠
    self.foldBtn.hidden = NO;
    [self.foldBtn setTitle:self.messageFrame.message.isFold?@"收起":@"全文" forState:0];
    self.foldBtn.frame = self.messageFrame.flodF;
}

#pragma mark 图片视图
- (void)addMessageImageView{
    
    self.messageImageView.hidden = NO;
    for (UIImageView *imageView in self.messageImageView.subviews) {
        [imageView removeFromSuperview];
    }
    
    [self.messageFrame.message.messageImageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect imageF = [self.messageFrame.imageFArr[idx] CGRectValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageF];
        
        SHPhotoBrowserModel *model = [[SHPhotoBrowserModel alloc]init];
        model.obj = obj;
        
        if (model.image) {//存在
            
            imageView.image = model.image;
        }else{
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.obj] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
        }
        
        if (!imageView.image) {
            imageView.image = [UIImage imageNamed:@"placeholderImage.png"];
        }
        
        imageView.tag = 1 + idx;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        
        //添加点击
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        
        [self.messageImageView addSubview:imageView];
        
    }];
    
    self.messageImageView.frame = [[self.messageFrame.imageFArr lastObject] CGRectValue];
}

#pragma mark 点赞视图
- (void)addMessageLikeView{
    
    self.likeView.hidden = NO;
    self.likeView.frame = self.messageFrame.likeF;
    
    NSMutableArray *linkArr = [[NSMutableArray alloc]init];
    
    __block NSInteger loc = 2;//加了点赞图标与空格
    __block NSInteger len = 0;
    //获取范围
    [self.messageFrame.message.likeListArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        len = obj.length;
        
        [linkArr addObject:@{@"parameter":obj,
                             @"range":[NSValue valueWithRange:NSMakeRange(loc, len)]}];
        loc += len+1;
    }];
    
    //找到内容视图
    for (UIView *view in self.likeView.subviews) {
        if ([view isKindOfClass:[SHClickTextView class]]) {
            SHClickTextView *textView = (SHClickTextView *)view;
            textView.frame = CGRectMake(0, 0, self.likeView.width, self.likeView.height);
            textView.attributedText = self.messageFrame.likeAtt;
            textView.linkArr = linkArr;
            break;
        }
    }
}

#pragma mark 评论视图
- (void)addMessageCommentView{
    
    self.commentView.hidden = NO;
    self.commentView.frame = self.messageFrame.commentF;
    
    self.commentView.commentArr = self.messageFrame.message.commentArr;
    
    NSMutableArray <UITapGestureRecognizer *>*gestArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.commentView.commentArr.count; i++) {
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentClick:)];
        [gestArr addObject:tapGest];
    }
    
    self.commentView.gestArr = gestArr;
    
    [self.commentView reloadView];
    
    WeakSelf;
    //回调
    self.commentView.block = ^(NSString *parameter, SHClickTextView *textView) {
        
        //用户点击
        if ([weakSelf.delegate respondsToSelector:@selector(messageUserClick:message:)]) {
            [weakSelf.delegate messageUserClick:weakSelf message:parameter];
        }
    };
}

@end
