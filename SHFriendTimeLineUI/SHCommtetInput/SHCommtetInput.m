//
//  SHCommtetInput.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/18.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHCommtetInput.h"
#import "SHEmotionKeyboard.h"

#define kUDMargin 10
#define kLRMargin 15

#define kCustomNavH 0

@interface SHCommtetInput ()
<UITextViewDelegate,
SHEmotionKeyboardDelegate>

//输入框
@property (nonatomic, strong) UITextView *inputView;
//表情控件
@property (nonatomic, strong) SHEmotionKeyboard *emotionKeyboard;
//键盘切换按钮
@property (nonatomic, strong) UIButton *keyBoardBtn;
//提示文字
@property (nonatomic, strong) UILabel *placeholderLable;

@end

@implementation SHCommtetInput

+ (instancetype)sharedSHCommtetInput{
    static SHCommtetInput *view;
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
        _inputView.layer.cornerRadius = 5;
        _inputView.layer.borderWidth = 1;
        _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputView.layer.masksToBounds = YES;
        _inputView.delegate = self;
        _inputView.font = [UIFont systemFontOfSize:16];
        _inputView.returnKeyType = UIReturnKeySend;
        
        [self addSubview:_inputView];
    }
    return _inputView;
}

- (UIButton *)keyBoardBtn{
    
    if (!_keyBoardBtn) {
        _keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_keyBoardBtn setBackgroundImage:[UIImage imageNamed:@"chat_face"] forState:UIControlStateNormal];
        [_keyBoardBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        [_keyBoardBtn addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_keyBoardBtn];
    }
    return _keyBoardBtn;
}

- (SHEmotionKeyboard *)emotionKeyboard {
    
    if (!_emotionKeyboard) {
        _emotionKeyboard = [SHEmotionKeyboard sharedSHEmotionKeyboard];
        _emotionKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, 205);
        _emotionKeyboard.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:247/255.0 alpha:1];
        _emotionKeyboard.delegate = self;
        _emotionKeyboard.toolBarArr = @[[NSString stringWithFormat:@"%lu",(unsigned long)SHEmoticonType_system]];
    }
    return _emotionKeyboard;
}

- (UILabel *)placeholderLable{
    
    if (!_placeholderLable) {
        _placeholderLable = [[UILabel alloc]init];
        _placeholderLable.backgroundColor = [UIColor clearColor];
        _placeholderLable.textColor = [UIColor lightGrayColor];
        _placeholderLable.text = @"评论";
        _placeholderLable.numberOfLines = 1;
        
        [self.inputView addSubview:_placeholderLable];
    }
    return _placeholderLable;
}

#pragma mark - 刷新View
- (void)reloadView{
    //背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    //分割线
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    
    //添加输入框
    self.inputView.frame = CGRectMake(kLRMargin, kUDMargin, self.frame.size.width - 3*kLRMargin - (self.frame.size.height - 2*kUDMargin) + 6, self.frame.size.height - 2*kUDMargin);
    
    //添加提示文字
    self.placeholderLable.frame = CGRectMake(5, self.inputView.textContainerInset.top, self.inputView.frame.size.width - 2*5, self.inputView.frame.size.height);
    self.placeholderLable.font = self.inputView.font;
//    [self.placeholderLable sizeToFit];
    
    //添加表情按钮
    self.keyBoardBtn.frame = CGRectMake(self.inputView.frame.size.width + 2*kLRMargin, kUDMargin + 3, self.frame.size.height - 2*kUDMargin - 6, self.frame.size.height - 2*kUDMargin - 6);
    //添加键盘通知
    [self addKeyboardNote];
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

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //先移除
    [center removeObserver:self];
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
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
    
    CGRect newFrame = self.frame;
    //微调导航栏
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - kCustomNavH;
    
    self.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark 键盘切换按钮的点击事件
- (void)keyBoardClick:(UIButton *)btn {
    
    //表情按钮切换背景图
    btn.selected = !btn.selected;
    
    [self.inputView resignFirstResponder];
    
    if (btn.selected) {//表情键盘显示
        
        self.inputView.inputView = self.emotionKeyboard;
    }else {//表情键盘隐藏
        
        self.inputView.inputView = nil;
    }
    [self.inputView becomeFirstResponder];
}

#pragma mark - textView的代理
#pragma mark 内容将要发生改变编辑
- (void)textViewDidChange:(UITextView *)textView{
    
    [self textViewChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {//回车键
        //发送文字
        if (self.block) {
            self.block(self.inputView.text,self.obj);
        }
        //清空输入框的内容
        self.inputView.text = nil;
        [self textViewChange];
        return NO;
    }
    return YES;
}

#pragma mark 文字改变
- (void)textViewChange{
    
    self.placeholderLable.hidden = self.inputView.text.length;
}

#pragma mark - SHEmotionKeyboardDelegate
#pragma mark 发送表情
- (void)emoticonInputSend
{
    //发送文字
    if (self.block) {
        self.block(self.inputView.text,self.obj);
    }
    //清空输入框的内容
    self.inputView.text = nil;
    [self textViewChange];
}

#pragma mark 获取表情对应字符
- (void)emoticonInputWithText:(NSString *)text Model:(SHEmotionModel *)model isSend:(BOOL)isSend{

    if (isSend) {//直接进行发送
        
    }else{
        //放到文本框
        [self.inputView insertText:text];
    }
    [self textViewChange];
}

#pragma mark - 显示
- (void)showSHCommtetInput{
    if (self.hidden) {
        self.hidden = NO;
        self.inputView.inputView = nil;
        [self.inputView becomeFirstResponder];
    }
}

#pragma mark - 隐藏
- (void)hideSHCommtetInput{
    
    if (!self.hidden) {
        self.hidden = YES;
        self.placeholderLable.text = @"评论";
        [self.inputView resignFirstResponder];
    }
}

#pragma mark - 销毁
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
