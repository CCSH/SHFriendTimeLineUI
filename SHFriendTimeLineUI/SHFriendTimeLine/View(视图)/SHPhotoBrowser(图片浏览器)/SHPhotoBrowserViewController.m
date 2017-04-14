//
//  SHPhotoBrowserViewController.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHPhotoBrowserViewController.h"
#import "SHPhotoTool.h"
#import "SHPhotoBrowserScrollView.h"
#import "ZLPhotoAssets.h"
#import "UIImageView+WebCache.h"

@interface SHPhotoBrowserViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>

// 图片展示
@property (nonatomic,weak) UICollectionView *collectionView;
// 提示文字展示
@property (nonatomic, weak) UILabel *pageLabel;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;

// 多选
@property (nonatomic, strong) UIActionSheet *sheet;

@end

@implementation SHPhotoBrowserViewController

static NSString *_cellIdentifier = @"collectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupReload];
    
    //不能隐藏的
//    在Info.plist 添加
//    
//    键值：View controller-based status bar appearance
//    
//    参数：NO
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setupReload{
    // 初始化动画
    if (self.photos.count){
        [self showToView];
    }
}

- (void)showToView{
    
    _photos = [_photos copy];
    
    [self reloadData];
    
    //加个背景盖上
    UIView *mainView = [[UIView alloc] init];
    mainView.frame = [UIScreen mainScreen].bounds;
    mainView.backgroundColor = [UIColor blackColor];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    //设置缩略图片
    SHPhotoBrowserModel *model = self.photos[self.currentIndex];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor blackColor];
    
    if (model.image) {//存在
        
        imageView.image = model.image;
    }else{
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.obj] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    }
    
    imageView.alpha = 1;
    imageView.backgroundColor = [UIColor clearColor];
    
    //添加效果
    switch (self.status) {
        case SHPhotoBrowserAnimationAnimationStatus_Fade://淡入淡出
        {
            mainView.alpha = 1;
        }
            break;
        case SHPhotoBrowserAnimationAnimationStatus_Zoom://放大缩小
        {
            imageView.frame = CGRectMake(mainView.frame.size.width/2, mainView.frame.size.height/2, 0, 0);
            [mainView addSubview:imageView];
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        switch (self.status) {
            case SHPhotoBrowserAnimationAnimationStatus_Fade://淡入淡出
            {
                mainView.alpha = 0;
            }
                break;
            case SHPhotoBrowserAnimationAnimationStatus_Zoom://放大缩小
            {
                imageView.frame = [SHPhotoTool setMaxMinZoomScalesForCurrentBoundWithImageView:imageView];
            }
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [mainView removeFromSuperview];
    }];
}

#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndex;
    }else{
        --self.currentPage;
    }
    
    if (self.currentPage >= self.photos.count) {
        self.currentPage = self.photos.count - 1;
    }
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    if (self.currentPage >= 0) {
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.frame.size.width , self.collectionView.contentOffset.y);
    }
    
    [self setPageLabelPage:self.currentPage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (collectionView.isDragging) {
        cell.hidden = NO;
    }
    
    if (self.photos.count) {
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        SHPhotoBrowserModel *model = self.photos[indexPath.item];
        
        CGRect tempF = [UIScreen mainScreen].bounds;
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = tempF;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        //展示图片
        SHPhotoBrowserScrollView *scrollView =  [[SHPhotoBrowserScrollView alloc] init];
        // 为了监听单击photoView事件
        scrollView.frame = tempF;
        scrollView.model = model;
        [scrollBoxView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        __weak typeof(self) weakSelf = self;
        
        scrollView.block = ^(SHPhotoBrowserImageClick type, SHPhotoBrowserScrollView *view) {
          
            switch (type) {
                case SHPhotoBrowserImageClick_tap://点击
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                    break;
                case SHPhotoBrowserImageClick_long://长按
                {
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
                    [sheet showInView:weakSelf.view];
                }
                    break;
                default:
                    break;
            }
        };
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
    if (currentPage == self.photos.count - 2) {
        currentPage = roundf((scrollView.contentOffset.x) / (scrollView.frame.size.width));
    }
    
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];

}

-(void)setPageLabelPage:(NSInteger)page{
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d / %ld",(int)page + 1, (unsigned long)self.photos.count];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (!buttonIndex){
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            SHPhotoBrowserModel *model = self.photos[self.currentPage];
            
            UIImage *image;
            if (model.image) {
                image= model.image;
            }else{
                image = [UIImage imageNamed:@"placeholderImage.png"];
            }
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                    NSLog(@"Save image fail：%@",error);
                }else{
                    NSLog(@"Save image succeed.");
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc{
    // 当没有数据的情况下
    if (!self.photos.count || self.photos.count <= self.currentIndex) {
        NSLog(@"图片浏览器：传入参数不对");
        return;
    }

    //进行跳转
    if (vc != nil) {
        [vc presentViewController:self animated:NO completion:nil];
    }
}

#pragma mark - 懒加载
#pragma mark photos
- (NSArray *)photos{
    if (!_photos) {
        _photos = [self getPhotos];
    }
    return _photos;
}

#pragma mark getPhotos
- (NSArray *)getPhotos{
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_photos.count];
    
    for (SHPhotoBrowserModel *photo in _photos) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeCenter;
        
        if (photo.image) {
            imageView.image = photo.image;
        }else{
           imageView.image = [UIImage imageNamed:@"placeholderImage.png"];
        }
        
        [photos addObject:imageView];
    }
    return photos;
}

#pragma mark collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 0, [UIScreen mainScreen].bounds.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-0)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
    }
    return _collectionView;
}

- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:pageLabel];
        [self.view bringSubviewToFront:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:[pageLabel(ZLPickerPageCtrlH)]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(30)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageLabel;
}

#pragma mark - 放大缩小一张图片的情况下（查看头像）
+ (void)showImageView:(UIImageView *)imageView originUrl:(NSString *)originUrl{
    
    
    SHPhotoBrowserModel *model = [[SHPhotoBrowserModel alloc]init];
    model.obj = imageView.image;
    model.originUrl = originUrl;
    //展示图片
    SHPhotoBrowserScrollView *scrollView =  [[SHPhotoBrowserScrollView alloc] init];
    // 为了监听单击photoView事件
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.model = model;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollView];
    
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scrollView.block = ^(SHPhotoBrowserImageClick type, SHPhotoBrowserScrollView *view) {
        
        switch (type) {
            case SHPhotoBrowserImageClick_tap://点击
            {
                [view removeFromSuperview];
            }
                break;
            case SHPhotoBrowserImageClick_long://长按
            {
                
            }
                break;
            default:
                break;
        }
    };
}

@end
