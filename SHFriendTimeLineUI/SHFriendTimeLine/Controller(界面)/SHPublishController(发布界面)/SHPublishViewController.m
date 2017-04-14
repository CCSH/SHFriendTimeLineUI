//
//  SHPublishViewController.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHPublishViewController.h"
#import "CSHTextView.h"

#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface SHPublishViewController ()<UITextViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>

//输入框
@property (nonatomic, strong) CSHTextView *textView;
//字数提示
@property (nonatomic, strong) UILabel * promptLabel;
//图片位置
@property (nonatomic, strong) UIScrollView *scrollView;
//图片数组
@property (nonatomic, strong) NSMutableArray *assets;
//图片数量
@property (nonatomic, assign) int phoneIndex;

@end

@implementation SHPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数组
    self.assets = [[NSMutableArray alloc] init];
    
    self.phoneIndex = 9;
    
    //添加导航栏
    [self setupNav];
    //添加输入框
     [self.view addSubview:self.textView];
    //添加提示文字
    [self.view addSubview:self.promptLabel];
    //添加图片选择
    [self.view addSubview:self.scrollView];
    //刷新scroll
    [self reloadScrollView];
    
}

- (void)setupNav{
    
    self.navigationItem.title = @"发布动态";
    
    //左上角
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    //右上角
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
}

- (void)leftClick{
    if (self.block) {
        self.block(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick{
    
    NSLog(@"\n 图片数组：%@ \n 输入文字：%@",self.assets,self.textView.text);
    
    if (self.textView.text.length || self.assets.count) {//内容存在或者图片存在
        if (self.block) {
            
            SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
            model.friendNick = UserName;
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 4];
            model.messageTime = @"1分钟前";
            model.messageContent = self.textView.text;
            model.messageImageArr = self.assets;
            
            self.block(model);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - 懒加载
#pragma mark - 输入框
- (CSHTextView *)textView{
    if (!_textView) {
        // 添加输入控件
        // 1.创建输入控件
        _textView = [[CSHTextView alloc] init];
        _textView.frame = CGRectMake(15,100,WIDTH - 30,140);
        _textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
        
        _textView.layer.cornerRadius = 1;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.delegate = self;
        // 2.设置提醒文字（占位文字）
        _textView.placehoder = @"说点什么吧...";
        // 3.设置字体
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

#pragma mark - 提示文字
- (UILabel *)promptLabel{
    if (!_promptLabel) {
        //提示文字
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.frame = CGRectMake(15, self.textView.frame.origin.y + self.textView.frame.size.height+10, WIDTH-30, 18);
        _promptLabel.textColor = [UIColor blackColor];
        _promptLabel.textAlignment = NSTextAlignmentRight;
        _promptLabel.font = [UIFont systemFontOfSize:15];
        _promptLabel.text = @"0/400字";
    }
    return _promptLabel;
}
#pragma mark - 图片展示
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        //图片展示
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, self.promptLabel.frame.origin.y+self.promptLabel.frame.size.height+10, self.view.frame.size.width, self.view.frame.size.height - (self.promptLabel.frame.origin.y+self.promptLabel.frame.size.height+10));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _scrollView;
}
#pragma mark - 绘制图片
- (void)reloadScrollView{
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 一行的最大列数
    int maxColsPerRow = 5;
    
    // 每个图片之间的间距
    CGFloat margin = 15;
    
    // 每个图片的宽高
    CGFloat imageViewW = ( self.view.frame.size.width- (maxColsPerRow + 1) * margin) / maxColsPerRow;
    CGFloat imageViewH = imageViewW;
    
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / maxColsPerRow;
        NSInteger col = i % maxColsPerRow;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=8.0;
        btn.frame = CGRectMake(col * (imageViewW + margin) + margin, row * (imageViewH + margin), imageViewW, imageViewH);
        
        
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            [btn setImage:[UIImage imageNamed:@"sendMessage_normal"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelectet) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn setTitle:@"" forState:1];
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[UIImage class]]){
                [btn setImage:self.assets[i] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
        }
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}
#pragma mark - 选择图片
- (void)photoSelectet{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 9
    pickerVc.maxCount = self.phoneIndex - self.assets.count;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Recoder Select Assets
    //    pickerVc.selectPickers = self.assets;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        [self.assets addObjectsFromArray: status.mutableCopy];
        [self reloadScrollView];
    };
    [pickerVc showPickerVc:self];
}
#pragma mark - 图片预览
- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
     //淡入淡出效果
     pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.assets;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}
#pragma mark - 图片删除
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self reloadScrollView];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    self.promptLabel.text = [NSString stringWithFormat:@"%lu/400字",(unsigned long)textView.text.length];
    if (textView.text.length > 400) {
        self.promptLabel.text = @"超出字数限制";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
