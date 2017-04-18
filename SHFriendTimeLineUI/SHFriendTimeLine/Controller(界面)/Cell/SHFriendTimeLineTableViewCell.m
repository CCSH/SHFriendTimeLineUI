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
- (UIButton *)openBtn{
    
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_openBtn];
    }
    return _openBtn;
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
        _timeLabel.font = kContentFont;
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
        [_deleteBtn addTarget:self action:@selector(deleteClock) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

#pragma mark 创建点赞
- (UIButton *)likeBtn{
    
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:0];
        [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

#pragma mark 创建点赞背景
- (UIImageView *)likeBGView{
    
    if (!_likeBGView) {
        _likeBGView = [[UIImageView alloc]init];
        UIImage *normal = [[UIImage imageNamed:@"like_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 45, 5, 5)];
        _likeBGView.image = normal;
        _likeBGView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_likeBGView];
    }
    return _likeBGView;
}

#pragma mark 创建评论背景
- (UIImageView *)commentBGView{
    
    if (!_commentBGView) {
        _commentBGView = [[UIImageView alloc]init];
        _commentBGView.backgroundColor = kRGB(240, 240, 240, 1);
        _commentBGView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_commentBGView];
    }
    return _commentBGView;
}

#pragma mark - 点击
#pragma mark 头像点击
- (void)avatarClick{
    
    if ([self.delegate respondsToSelector:@selector(messageUserClick:Message:)]) {
        [self.delegate messageUserClick:self Message:self.messageFrame.message.friendNick];
    }
}

#pragma mark 展开点击
- (void)openClick{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:Message:ClickType:)]) {
        [self.delegate messageClick:self Message:self.messageFrame ClickType:SHFriendTimeLineClickType_open];
    }
}

#pragma mark 点赞点击
- (void)likeClick{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:Message:ClickType:)]) {
        [self.delegate messageClick:self Message:self.messageFrame ClickType:SHFriendTimeLineClickType_like_comment];
    }
}

- (void)deleteClock{
    
    if ([self.delegate respondsToSelector:@selector(messageClick:Message:ClickType:)]) {
        [self.delegate messageClick:self Message:self.messageFrame ClickType:SHFriendTimeLineClickType_delete];
    }
}

#pragma mark 图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(imageClick:Message:Index:)]) {
        [self.delegate imageClick:self Message:self.messageFrame Index:tap.view.tag - 1];
    }
}

#pragma mark - 内容及Frame设置
- (void)setMessageFrame:(SHFriendTimeLineFrame *)messageFrame{
    _messageFrame = messageFrame;
    
    SHFriendTimeLine *message = messageFrame.message;
    
    //初始化
    self.contentTextView.hidden = YES;
    self.messageImageView.hidden = YES;
    self.likeBGView.hidden = YES;
    self.commentBGView.hidden = YES;
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
    
    //7、 点赞按钮
    self.likeBtn.frame = messageFrame.likeF;
    
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
    
    //移除之前的视图
    for (SHClickTextView *view in self.likeViewArr) {
        [view removeFromSuperview];
    }
    
    self.likeBGView.hidden = NO;
    self.likeBGView.frame = self.messageFrame.likeListF;
    
    NSString *likeList = [self.messageFrame.message.likeListArr componentsJoinedByString:@"、"];
    
    __block NSMutableAttributedString *likeAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",likeList]];
    
    //添加点赞图片
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = [UIImage imageNamed:@"like.png"];
    
    //位置微调
    textAttachment.bounds = CGRectMake(0, -2, 15, 15);
    
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //替换为图片附件
    [likeAtt replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:imageStr];
    
    NSMutableArray *rangArr = [[NSMutableArray alloc]init];
    NSMutableArray *parameterArr = [[NSMutableArray alloc]init];
    
    __block NSInteger loc = 2;
    __block NSInteger len = 0;
    //获取范围
    [self.messageFrame.message.likeListArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        len = obj.length;
        
        [rangArr addObject:[NSValue valueWithRange:NSMakeRange(loc, len)]];
        
        [parameterArr addObject:obj];
        
        loc += len+1;
    }];
    
    SHClickTextView *textView = [[SHClickTextView alloc]initWithFrame:CGRectMake(kLRMargin, kLikeAngleH + kUDMargin, self.messageFrame.likeListF.size.width - 2*kLRMargin, self.messageFrame.likeListF.size.height - 2*kUDMargin - kLikeAngleH)];
    textView.backgroundColor = [UIColor clearColor];
    textView.attributedText = likeAtt;
    textView.font = kContentFont;

    //文字参数
    NSDictionary *dic = @{NSForegroundColorAttributeName:kRGB(51, 84, 135, 1)};
    //添加点击
    [textView addClickWithSupVC:self RangArr:rangArr ParameterArr:parameterArr linkAddAttribute:dic block:^(CGPoint point, SHClickTextView *textView) {
        
        textView = self.likeViewArr[0];
        //查找点击位置
        [textView.linkArray enumerateObjectsUsingBlock:^(SHClickTextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            for (id rect in obj.rects) {
                //是否在点击位置
                if (CGRectContainsPoint([rect CGRectValue], point)) {
                    
                    //回调
                    if ([self.delegate respondsToSelector:@selector(messageUserClick:Message:)]) {
                        [self.delegate messageUserClick:self Message:obj.parameter];
                    }
                    return ;
                }
            }
        }];
        //点击了空白处
    }];
    
    [self.likeBGView addSubview:textView];
    self.likeViewArr = @[textView];
}

#pragma mark 评论视图
- (void)addMessageCommentView{
    
    //移除之前的视图
    for (SHClickTextView *view in self.commentViewArr) {
        [view removeFromSuperview];
    }
    
    self.commentBGView.hidden = NO;
    self.commentBGView.frame = self.messageFrame.commentF;
    
    __block NSInteger loc = 0;
    __block NSInteger len = 0;
    
    NSMutableArray <SHClickTextView *>*commentViewArr = [[NSMutableArray alloc]init];
    
    //获取评论数组
    [self.messageFrame.message.commentArr enumerateObjectsUsingBlock:^(SHFriendTimeLineComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //定义内容
        NSMutableAttributedString *commentAtt;
        //范围集合
        NSMutableArray *rangeArr = [[NSMutableArray alloc]init];
        //参数集合
        NSMutableArray *parameterArr = [[NSMutableArray alloc]init];
        
        len = obj.comment.length;
        
        if (obj.replier) {//存在回复人
            
            commentAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@:%@",obj.comment,obj.replier,obj.content]];
            //获取范围
            NSRange replierRange = {len + 2, obj.replier.length};
            
            [rangeArr addObject:[NSValue valueWithRange:replierRange]];
            [parameterArr addObject:obj.replier];
        }else{
            
            commentAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",obj.comment,obj.content]];
        }
        
        NSRange range = NSMakeRange(loc, len);
        
        [rangeArr addObject:[NSValue valueWithRange:range]];
        [parameterArr addObject:obj.comment];
        
        SHClickTextView *textView = [[SHClickTextView alloc]initWithFrame:[self.messageFrame.commentFArr[idx] CGRectValue]];
        textView.backgroundColor = [UIColor clearColor];
        
        textView.attributedText = commentAtt;
        textView.font = kContentFont;
        textView.parameter = obj;
        
        //文字参数
        NSDictionary *dic = @{NSForegroundColorAttributeName:kRGB(51, 84, 135, 1)};
        //添加点击
        [textView addClickWithSupVC:self RangArr:rangeArr ParameterArr:parameterArr linkAddAttribute:dic block:^(CGPoint point, SHClickTextView *textView) {
            [self.commentViewArr enumerateObjectsUsingBlock:^(SHClickTextView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:textView]) {
                    __block SHClickTextModel *clickTextModel = nil;
                    
                    //查找点击位置
                    [obj.linkArray enumerateObjectsUsingBlock:^(SHClickTextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        for (id rect in obj.rects) {
                            //是否在点击位置
                            if (CGRectContainsPoint([rect CGRectValue], point)) {
                                clickTextModel = obj;
                                *stop = YES;
                            }
                        }
                    }];
                    
                    if (clickTextModel) {//存在
                        
                        //回调
                        if ([self.delegate respondsToSelector:@selector(messageUserClick:Message:)]) {
                            [self.delegate messageUserClick:self Message:clickTextModel.parameter];
                        }
                        
                    }else{
                        
                        //回调
                        if ([self.delegate respondsToSelector:@selector(messageCommentClick:Message:)]) {
                            SHFriendTimeLineComment *commentModel = textView.parameter;
                            [self.delegate messageCommentClick:self Message:commentModel];
                        }
                    }
                }
            }];
        }];
        [self.commentBGView addSubview:textView];
        [commentViewArr addObject:textView];
    }];
    self.commentViewArr = commentViewArr;
}

@end
