//
//  SHClickTextView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/6.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击链点model
 */
@interface SHClickTextModel : NSObject
//点击位置
@property (nonatomic, assign) NSInteger index;
//携带参数(用户信息什么的)
@property (nonatomic, strong) id parameter;
//点击范围
@property (nonatomic, assign) NSRange range;
//矩形框数组
@property (nonatomic, strong) NSArray *rects;

@end

@class SHClickTextView;
/**
 文字局部点击回调
 */
typedef void (^SHClickTextBlock)(CGPoint point,SHClickTextView *textView);
/**
 文字局部点击视图
 */
@interface SHClickTextView : UITextView<UITextViewDelegate>

//视图携带参数
@property (nonatomic, strong) id parameter;
//点击集合
@property (nonatomic, strong) NSMutableArray <SHClickTextModel *>*linkArray;
//回调
@property (nonatomic, strong) SHClickTextBlock block;

/**
 添加点击(多个)
 
 @param rangArr 范围集合
 @param parameterArr 参数集合
 @param linkDic 属性(暂时不用集合)
 @param block 回调
 */
- (void)addClickWithSupVC:(UIView *)supVC RangArr:(NSArray *)rangArr ParameterArr:(NSArray *)parameterArr linkAddAttribute:(NSDictionary *)linkDic block:(SHClickTextBlock)block;

/**
 添加点击(一个)
 
 @param rang 范围
 @param parameter 参数
 @param linkDic 属性
 @param block 回调
 */
- (void)addClickWithSupVC:(UIView *)supVC Rang:(id)rang Index:(NSInteger)index Parameter:(id)parameter linkAddAttribute:(NSDictionary *)linkDic block:(SHClickTextBlock)block;

@end

