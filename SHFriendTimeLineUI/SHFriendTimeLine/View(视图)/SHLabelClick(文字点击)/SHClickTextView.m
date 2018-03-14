//
//  SHClickTextView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/6.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHClickTextView.h"

@implementation SHClickTextModel

@end

@implementation SHClickTextView

#pragma mark - 实例化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setup];
}

#pragma mark - 初始化
- (void)setup{
    
    self.userInteractionEnabled = YES;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.editable = YES;
    self.delegate = self;
    [self.linkArray removeAllObjects];
    //添加点击
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark - 懒加载
- (NSMutableArray *)linkArray {
    if (!_linkArray) {
        _linkArray = [[NSMutableArray alloc]init];
    }
    return _linkArray;
}

#pragma mark - 添加点击
#pragma mark 多个
- (void)addClickWithSupVC:(UIView *)supVC RangArr:(NSArray *)rangArr ParameterArr:(NSArray *)parameterArr linkAddAttribute:(NSDictionary *)linkDic block:(SHClickTextBlock)block{
    
    [rangArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addClickWithSupVC:supVC Rang:obj Index:idx Parameter:parameterArr[idx] linkAddAttribute:linkDic block:block];
    }];
}

#pragma mark 一个
- (void)addClickWithSupVC:(UIView *)supVC Rang:(id)rang Index:(NSInteger)index Parameter:(id)parameter linkAddAttribute:(NSDictionary *)linkDic block:(SHClickTextBlock)block{
    
    self.block = block;
    //拿到字符串
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //为点击的字符串添加属性
    if (linkDic && linkDic.count > 0 && atrString.length > 0) {
        NSEnumerator *enumerator = [linkDic keyEnumerator];
        id key;
        while ((key = [enumerator nextObject])) {
            
            [atrString addAttributes:linkDic range:[rang rangeValue]];
        }
    }
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    [atrString addAttributes:attributes range:NSMakeRange(0, atrString.length)];
    
    self.attributedText = atrString;
    
    //计算点击位置存起来
    self.selectedRange = [rang rangeValue];
    NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
    self.selectedRange = NSMakeRange(0, 0);
    
    NSMutableArray *rects  = [NSMutableArray array];
    for (UITextSelectionRect *selectionRect  in selectionRects) {
        
        CGRect rect = selectionRect.rect;
        if (!rect.size.width||!rect.size.height){
            continue;
        }else{
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    
    //初始化模型
    SHClickTextModel *linkModel = [[SHClickTextModel alloc] init];
    linkModel.index = index;
    linkModel.range = [rang rangeValue];
    linkModel.parameter = parameter;
    linkModel.rects = rects;
    
    if (linkModel) {
        //添加点击
        [self.linkArray addObject:linkModel];
    }
}

#pragma mark - 添加点击
- (void)labelClick:(UITapGestureRecognizer *)tap{
    
    if (self.block) {
        self.block([tap locationInView:self],self);
    }
}



@end

