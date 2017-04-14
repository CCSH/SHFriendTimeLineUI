//
//  SHPhotoBrowserScrollView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHPhotoBrowserScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "DACircularProgressView.h"

@interface SHPhotoBrowserScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *photoImageView;
//加载进度
@property (strong,nonatomic) DACircularProgressView *progressView;

@end

@implementation SHPhotoBrowserScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //点击
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        //长按
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongClick:)]];
        
        //设置图片
        UIImageView *photoImageView = [[UIImageView alloc]init];
        photoImageView.backgroundColor = [UIColor blackColor];
        photoImageView.contentMode = UIViewContentModeCenter;
        _photoImageView = photoImageView;
        [self addSubview:_photoImageView];
        
        //设置加载进度
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake(0, 0, 40, 40);
        progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        progressView.roundedCorners = YES;
        progressView.thicknessRatio = 0.2;
        progressView.hidden = YES;
        self.progressView = progressView;
        [self addSubview:self.progressView];
        
    }
    return self;
}

#pragma mark - 点击
#pragma mark 图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap{

    if (self.block) {
        self.block(SHPhotoBrowserImageClick_tap,self);
    }
}
#pragma mark 图片长按
- (void)imageLongClick:(UILongPressGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.block) {
            self.block(SHPhotoBrowserImageClick_long,self);
        }
    }
}

#pragma mark - SET
- (void)setModel:(SHPhotoBrowserModel *)model{
    
    _model = model;
    
    if (model.image) {//存在图片
        _photoImageView.image = model.image;
        [self displayImage];
    }else{
        //网络URL
        [_photoImageView sd_setImageWithURL:model.obj placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //调整进度
            [self setProgress:(double)receivedSize / expectedSize];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self setProgress:1.0];
                [self displayImage];
            }else{//加载失败
                
            }
        }];
    }
}

#pragma mark - setProgress
- (void)setProgress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = NO;
        if (progress == 0) {
            [self.progressView setProgress:0.01 animated:YES];
            return;
        }
        if (progress / 1.0 != 1.0) {
            [self.progressView setProgress:progress animated:YES];
        }else{
            [self.progressView removeFromSuperview];
            self.progressView = nil;
        }
    });
}

#pragma mark - Image
// Get and display image
- (void)displayImage {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    // Get image from browser as it handles ordering of fetching
    UIImage *img = _photoImageView.image;
    if (img) {
        
        _photoImageView.hidden = NO;
        
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = img.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        
    }
    [self setNeedsLayout];
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_photoImageView.image == nil) return;
    
    //    _photoImageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:_photoImageView];
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    
    CGFloat minScale = MIN(xScale, yScale);
    // CGFloat maxScale = MAX(xScale, yScale);
    // use minimum of these to allow the image to become fully visible
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    self.maximumZoomScale = xScale * 2;
    self.minimumZoomScale = xScale;
    
    self.zoomScale = self.minimumZoomScale;
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        if (yScale >= xScale) {
            self.scrollEnabled = NO;
        }
    }
    
    self.contentOffset = CGPointMake(0, 0);
    self.contentSize = CGSizeMake(0, self.contentSize.height);
    // Layout
    [self setNeedsLayout];
    
}

#pragma mark - Layout
- (void)layoutSubviews {
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
