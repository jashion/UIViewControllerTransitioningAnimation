//
//  PhotoCircleController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/9.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PhotoCircleController.h"
#import "FXBlurView.h"

#define kScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define photoContentViewHeight (kScreenHeight - 260)
#define photoContentViewWidth (kScreenWidth - 100)
#define angle  (M_PI_2 / 9)
#define changeHeight 80
#define frontCenter CGPointMake(kScreenWidth / 2, kScreenHeight / 2 + changeHeight)
#define currentCenter CGPointMake(kScreenWidth * 3 / 2, kScreenHeight / 2)
#define nextCenter CGPointMake(kScreenWidth * 5 / 2, kScreenHeight / 2 + changeHeight)

@interface PhotoCircleController ()<UIScrollViewDelegate>

@end

@implementation PhotoCircleController
{
    NSArray *imagesArray;
    NSInteger currentImageIndex;
    UIImageView *backgroundImageView;
    UIScrollView *myScrollView;
    UIButton *cancelButton;
    UIView *frontContentView;
    UIView *currentContentView;
    UIView *nextContentView;
    UIImageView *frontImageView;
    UIImageView *currentImageView;
    UIImageView *nextImageView;
}

- (instancetype)initWithImages: (NSArray *)images currentImageIndex: (NSInteger)index {
    if (self = [super init]) {
        imagesArray = images;
        currentImageIndex = index;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIImage *image = [UIImage imageNamed: imagesArray[currentImageIndex]];
    image = [image blurredImageWithRadius: 5 iterations: 10 tintColor: [UIColor blackColor]];
    backgroundImageView = [[UIImageView alloc] initWithImage: image];
    backgroundImageView.frame = [UIScreen mainScreen].bounds;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview: backgroundImageView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    myScrollView.scrollEnabled = YES;
    myScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    myScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    myScrollView.delegate = self;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.pagingEnabled = YES;
    [self.view addSubview: myScrollView];
    
    cancelButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelButton.bounds = CGRectMake(0, 0, 36, 36);
    cancelButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60);
    cancelButton.backgroundColor = [UIColor blackColor];
    cancelButton.layer.cornerRadius = 18;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.contentMode = UIViewContentModeScaleAspectFit;
    cancelButton.alpha = 0;
    cancelButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [cancelButton setImage: [UIImage imageNamed:@"DeleteIcon"] forState: UIControlStateNormal];
    [cancelButton addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: cancelButton];
    
    UIBezierPath *path = [self createBezierPath];
    
    CAShapeLayer *frontMaskLayer = [self createMaskLayerWithPath: path.CGPath];
    CAShapeLayer *currentMaskLayer = [self createMaskLayerWithPath: path.CGPath];
    CAShapeLayer *nextMaskLayer = [self createMaskLayerWithPath: path.CGPath];
    
    frontContentView = [self buildPhotoViewWithCenter: frontCenter maskLayer: frontMaskLayer];
    frontContentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - angle);
    [myScrollView addSubview: frontContentView];
    currentContentView = [self buildPhotoViewWithCenter: currentCenter maskLayer: currentMaskLayer];
    [myScrollView addSubview: currentContentView];
    nextContentView = [self buildPhotoViewWithCenter: nextCenter maskLayer: nextMaskLayer];
    nextContentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    [myScrollView addSubview: nextContentView];
    
    frontImageView = [self buildImageView];
    frontImageView.image = [self frontImageWithIndex: currentImageIndex];
    [frontContentView addSubview: frontImageView];
    currentImageView = [self buildImageView];
    currentImageView.image = [self currentImageWithIndex: currentImageIndex];
    [currentContentView addSubview: currentImageView];
    nextImageView = [self buildImageView];
    nextImageView.image = [self nextImageWithIndex: currentImageIndex];
    [nextContentView addSubview: nextImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [UIView animateWithDuration: 0.6 delay: 0.0 usingSpringWithDamping: 0.6 initialSpringVelocity: 1.f options: UIViewAnimationOptionCurveEaseIn animations:^{
        cancelButton.alpha = 1;
        cancelButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX >= 0 && offsetX <= kScreenWidth) {
        CGFloat percent = 1 - offsetX / kScreenWidth;  //offsetX = 0 ,percent = 1; offsetX = kScreenWidth ,percent = 0.
        frontContentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (percent - 1 ) * angle);
        frontContentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 + (1 - percent) * changeHeight);
        currentContentView.transform = CGAffineTransformMakeRotation(percent * angle);
        currentContentView.center = CGPointMake(kScreenWidth * 3 / 2, kScreenHeight / 2 + percent * changeHeight);
    } else if (offsetX > kScreenWidth && offsetX <= kScreenWidth * 2) {
        CGFloat percent = (offsetX - kScreenWidth) / kScreenWidth;  //offsetX = kScreenWidth,percent = 0; offsetX = kScreenWidth * 2,percent = 1.
        nextContentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (1 - percent) * angle);
        nextContentView.center = CGPointMake(kScreenWidth * 5 / 2, kScreenHeight / 2 + (1- percent) * changeHeight);
        currentContentView.transform = CGAffineTransformMakeRotation(- percent * angle);
        currentContentView.center = CGPointMake(kScreenWidth * 3 / 2, kScreenHeight / 2 + percent * changeHeight);
    }
    
    if (offsetX == 0) {
        currentImageIndex = currentImageIndex == 0 ? imagesArray.count - 1: currentImageIndex - 1;
        frontImageView.image = [self frontImageWithIndex: currentImageIndex];
        currentImageView.image = [self currentImageWithIndex: currentImageIndex];
        nextImageView.image = [self nextImageWithIndex: currentImageIndex];
        [myScrollView setContentOffset: CGPointMake(kScreenWidth, 0)];
    } else if (offsetX == kScreenWidth * 2) {
        currentImageIndex = currentImageIndex == (imagesArray.count - 1) ? 0: currentImageIndex + 1;
        frontImageView.image = [self frontImageWithIndex: currentImageIndex];
        currentImageView.image = [self currentImageWithIndex: currentImageIndex];
        nextImageView.image = [self nextImageWithIndex: currentImageIndex];
        [myScrollView setContentOffset: CGPointMake(kScreenWidth, 0)];
    }
    
    backgroundImageView.image = [[UIImage imageNamed: imagesArray[currentImageIndex]] blurredImageWithRadius: 5 iterations: 10 tintColor: [UIColor blackColor]];
}

#pragma mark - Event Response

- (void)back {
    if (self.delegate && [self.delegate respondsToSelector: @selector(dismissController:)]) {
        [self.delegate dismissController: self];
    }
}

#pragma mark - Private Method

- (UIView *)buildPhotoViewWithCenter: (CGPoint)center maskLayer: (CAShapeLayer *)maskLayer {
    UIView *photoView = [[UIView alloc] init];
    photoView.bounds = CGRectMake(0, 0, photoContentViewWidth, photoContentViewHeight);
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.center = center;
    photoView.layer.mask = maskLayer;
    photoView.layer.cornerRadius = 80;
    photoView.clipsToBounds = YES;
    
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(10, photoContentViewWidth * 3 / 4 + 30, photoContentViewWidth - 20, 50)];
    title.font = [UIFont systemFontOfSize: 20];
    title.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"每把枪，都印刻着一段记忆难以释怀！";
    [photoView addSubview: title];
    
    UIButton *likeButton = [self createButtonWithImage: [UIImage imageNamed:@"LikeIcon"] title: @"4553" frame: CGRectMake(50, photoContentViewHeight - 100, 50, 50)];
    [photoView addSubview: likeButton];
    UIButton *commentButton = [self createButtonWithImage: [UIImage imageNamed:@"CommentIcon"] title: @"1033" frame: CGRectMake(photoContentViewWidth / 2 - 25, photoContentViewHeight - 100, 50, 50)];
    [photoView addSubview: commentButton];
    UIButton *focusButton = [self createButtonWithImage: [UIImage imageNamed:@"FollowIcon"] title: @"120" frame: CGRectMake(photoContentViewWidth - 100, photoContentViewHeight - 100, 50, 50)];
    [photoView addSubview: focusButton];
    
    return photoView;
}

- (UIButton *)createButtonWithImage: (UIImage *)image title: (NSString *)title frame: (CGRect)frame {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    button.titleEdgeInsets = UIEdgeInsetsMake(26, 0, 0, 0);
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithWhite:0.200 alpha:1.000] forState: UIControlStateNormal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.bounds = CGRectMake(0, 0, frame.size.height / 2, frame.size.height / 2);
    imageView.center = CGPointMake(frame.size.width / 2, frame.size.height / 4);
    [button addSubview: imageView];
    return button;
}

- (UIImageView *)buildImageView {
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, photoContentViewWidth, photoContentViewWidth * 3 / 4)];
    topImageView.clipsToBounds = YES;
    return topImageView;
}

- (UIBezierPath *)createBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(10, 40)];
    [path addQuadCurveToPoint: CGPointMake(photoContentViewWidth - 10, 40) controlPoint: CGPointMake(photoContentViewWidth / 2, 0)];
    [path addQuadCurveToPoint: CGPointMake(photoContentViewWidth - 10, photoContentViewHeight - 40) controlPoint: CGPointMake(photoContentViewWidth, photoContentViewHeight / 2)];
    [path addQuadCurveToPoint: CGPointMake(10, photoContentViewHeight - 40) controlPoint: CGPointMake(photoContentViewWidth / 2, photoContentViewHeight)];
    [path addQuadCurveToPoint: CGPointMake(10, 40) controlPoint: CGPointMake(0, photoContentViewHeight / 2)];
    [path closePath];
    return path;
}

- (CAShapeLayer *)createMaskLayerWithPath: (CGPathRef)path {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, photoContentViewWidth, photoContentViewHeight);
    maskLayer.path = path;
    return maskLayer;
}

- (UIImage *)frontImageWithIndex: (NSInteger)index {
    if (index == 0) {
        return [UIImage imageNamed: imagesArray[imagesArray.count - 1]];
    } else if (index == (imagesArray.count - 1)) {
        return [UIImage imageNamed: imagesArray[imagesArray.count - 2]];
    } else {
        return [UIImage imageNamed: imagesArray[currentImageIndex - 1]];
    }
}

- (UIImage *)currentImageWithIndex: (NSInteger)index {
    if (index == 0) {
        return [UIImage imageNamed: imagesArray[0]];
    } else if (index == (imagesArray.count - 1)) {
        return [UIImage imageNamed: imagesArray[imagesArray.count - 1]];
    } else {
        return [UIImage imageNamed: imagesArray[currentImageIndex]];
    }
}

- (UIImage *)nextImageWithIndex: (NSInteger)index {
    if (index == 0) {
        return [UIImage imageNamed: imagesArray[1]];
    } else if (index == (imagesArray.count - 1)) {
        return [UIImage imageNamed: imagesArray[0]];
    } else {
        return [UIImage imageNamed: imagesArray[currentImageIndex + 1]];
    }
}

@end
