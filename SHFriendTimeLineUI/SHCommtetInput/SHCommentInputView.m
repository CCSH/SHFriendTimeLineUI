//
//  SHCommentInputView.m
//  KeyBoard
//
//  Created by CSH on 2017/4/17.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHCommentInputView.h"
#import "SHFriendTimeLineHeader.h"

//设备物理宽度宽高
#define SHHeight ([UIScreen mainScreen].bounds.size.height)
#define SHWidth ([UIScreen mainScreen].bounds.size.width)

#define kCUDMargin 10
#define kCLRMargin 15

@interface SHCommentInputView ()<UITextViewDelegate,SHEmotionKeyboardDelegate>

//输入框
@property (nonatomic, strong) UITextView *inputView;
//表情控件
@property (nonatomic, strong) SHEmotionKeyboard *emotionKeyboard;
//表情按钮
@property (nonatomic, strong) UIButton *emotionBtn;
//提示文字
@property (nonatomic, strong) UILabel *placeholderLable;

@end

@implementation SHCommentInputView

+ (instancetype)sharedSHCommentInputView{
    static SHCommentInputView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!view) {
            view = [[self alloc]init];
        }
    });
    return view;
}

#pragma mark - 懒加载
- (UITextView *)inputView{
    
    if (!_inputView) {
        _inputView = [[UITextView alloc] init];
//        _inputView.layer.cornerRadius = 5;
//        _inputView.layer.borderWidth = 1;
//        _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _inputView.layer.masksToBounds = YES;
        _inputView.delegate = self;
        _inputView.font = [UIFont systemFontOfSize:16];
        _inputView.returnKeyType = UIReturnKeySend;
        
        [self addSubview:_inputView];
    }
    return _inputView;
}

- (UIButton *)emotionBtn{
    
    if (!_emotionBtn) {
        _emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emotionBtn setBackgroundImage:[UIImage imageNamed:@"chat_face"] forState:UIControlStateNormal];
        [_emotionBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        [_emotionBtn addTarget:self action:@selector(emotionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emotionBtn];
    }
    return _emotionBtn;
}

- (SHEmotionKeyboard *)emotionKeyboard {
    
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[SHEmotionKeyboard alloc]init];
        _emotionKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, 205);
        _emotionKeyboard.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:247/255.0 alpha:1];
        _emotionKeyboard.delegate = self;
        _emotionKeyboard.toolBarArr = @[[NSString stringWithFormat:@"%lu",(unsigned long)SHEmoticonType_system]];
        [_emotionKeyboard reloadView];
    }
    
    return _emotionKeyboard;
}

- (UILabel *)placeholderLable{
    
    if (!_placeholderLable) {
        _placeholderLable = [[UILabel alloc]init];
        _placeholderLable.backgroundColor = [UIColor clearColor];
        _placeholderLable.textColor = [UIColor lightGrayColor];
        _placeholderLable.text = @"评论";
        
        [self.inputView addSubview:_placeholderLable];
    }
    return _placeholderLable;
}

- (void)reloadView{
    self.emotionKeyboard = nil;
    //设置
    [self setUI];
}

#pragma mark - SET
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLable.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLable.textColor = placeholderColor;
}

#pragma mark - 搭建界面
- (void)setUI {
    
    self.x = self.x - 1;
    self.width = self.width + 2;

    //背景颜色
    self.backgroundColor = kRGB(243, 243, 247, 1);
    
    //分割线
    self.layer.borderColor = kRGB(214, 214, 214, 1).CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    
    //添加输入框
    self.inputView.frame = CGRectMake(kCLRMargin, kCUDMargin, self.frame.size.width - 3*kCLRMargin - (self.frame.size.height - 2*kCUDMargin) + 6, self.frame.size.height - 2*kCUDMargin);

    //添加提示文字
    self.placeholderLable.frame = CGRectMake(5, 3, self.inputView.frame.size.width - 2*5, self.inputView.frame.size.height);
    self.placeholderLable.font = self.inputView.font;

    //添加表情按钮
    self.emotionBtn.frame = CGRectMake(self.inputView.frame.size.width + 2*kCLRMargin, kCUDMargin + 3, self.frame.size.height - 2*kCUDMargin - 6, self.frame.size.height - 2*kCUDMargin - 6);
    //添加键盘通知
    [self addKeyboardNote];
}

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(hideCommentInput) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    self.y = kSHHeight - keyboardEndFrame.size.height - self.height;
    
    [UIView commitAnimations];
}

#pragma mark 表情按钮的点击事件
- (void)emotionBtnClick:(UIButton *)emotionBtn {
    
    //表情按钮切换背景图
    self.emotionBtn.selected = !self.emotionBtn.selected;
    
    [self.inputView resignFirstResponder];

    if (self.emotionBtn.selected) {//表情键盘显示
    
        self.inputView.inputView = self.emotionKeyboard;
    }else {//表情键盘隐藏
        
        self.inputView.inputView = nil;
    }
    [self.inputView becomeFirstResponder];
}

#pragma mark - textView的代理
#pragma mark 内容将要发生改变编辑
- (void)textViewDidChange:(UITextView *)textView{

    self.placeholderLable.hidden = textView.text.length;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {//回车键
        //发送文字
        if (self.block) {
            self.block(self.inputView.text,self);
        }
        //清空输入框的内容
        self.inputView.text = nil;
        self.placeholderLable.hidden = self.inputView.text.length;
        return NO;
    }
    return YES;
}

#pragma mark - SHEmotionKeyboardDelegate
#pragma mark 发送表情
- (void)emoticonInputSend
{
    //发送文字
    if (self.block) {
        self.block(self.inputView.text,self);
    }
    //清空输入框的内容
    self.inputView.text = nil;
    self.placeholderLable.hidden = self.inputView.text.length;
}

#pragma mark 获取表情对应字符
- (void)emoticonInputWithText:(NSString *)text model:(SHEmotionModel *)model isSend:(BOOL)isSend{
    self.placeholderLable.hidden = self.inputView.text.length;
    if (isSend) {//直接进行发送
        
    }else{
        //放到文本框
        [self.inputView insertText:text];
    }
}

#pragma mark - 显示
- (void)showCommentInput{
    self.emotionBtn.selected = NO;
    self.placeholderLable.hidden = NO;
    self.inputView.text = @"";
    [self.inputView becomeFirstResponder];
}

#pragma mark - 隐藏
- (void)hideCommentInput{
    
    if (self.frame.origin.y < SHHeight) {
        
        self.inputView.inputView = nil;
        self.placeholderLable.text = @"评论";
        [self.inputView resignFirstResponder];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.y = SHHeight;
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
