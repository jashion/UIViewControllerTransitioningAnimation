//
//  AppDelegate.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "objc/runtime.h"
#import "ColorUtils.h"
#import "BMAnimateTransition.h"
#import "BMInteractiveTransition.h"
#import "UIImage+Tint.h"

#define kRect [UIScreen mainScreen].bounds

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, assign) CGPoint tapPoint;
@property (nonatomic, strong) BMAnimateTransition *transition;
@property (nonatomic, strong) BMInteractiveTransition *interactive;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIImageView *splashView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self createTabController];
    [self.window makeKeyAndVisible];
    self.transition = [BMAnimateTransition new];
    self.transition.operation = BMAnimateTransitionTabBarCircleLayer;
    [self lanuchSplashAnimation];
    return YES;
}

#pragma mark - Private Method

- (UITabBarController *)createTabController {
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController: home];
    homeNav.navigationBar.tintColor = [ColorUtils mainColor];
    homeNav.tabBarItem.title = @"Home";
    homeNav.tabBarItem.image = [UIImage imageNamed:@"HomeUnSelect"];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"HomeSelect"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    
    MessageViewController *message = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController: message];
    messageNav.navigationBar.tintColor = [ColorUtils mainColor];
    messageNav.tabBarItem.title = @"Message";
    messageNav.tabBarItem.image = [UIImage imageNamed:@"MessageUnSelect"];
    messageNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"MessageSelect"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    
    SettingViewController *setting = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController: setting];
    settingNav.navigationBar.tintColor = [ColorUtils mainColor];
    settingNav.tabBarItem.title = @"Setting";
    settingNav.tabBarItem.image = [UIImage imageNamed:@"SettingUnSelect"];
    settingNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"SettingSelect"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeNav, messageNav, settingNav];
    tabBarController.tabBar.tintColor = [ColorUtils mainColor];
    tabBarController.delegate = self;
    return tabBarController;
}

- (void)lanuchSplashAnimation {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.container = [[UIView alloc] initWithFrame: rect];
    self.container.backgroundColor = [UIColor whiteColor];
    [self.window addSubview: self.container];
    
    self.splashView = [[UIImageView alloc] initWithFrame: self.container.bounds];
    self.splashView.image = [UIImage imageNamed:@"LauncgSplashImage"];
    self.splashView.alpha = 0;
    [self.container addSubview: self.splashView];
    
    self.maskView = [[UIImageView alloc] initWithImage: [[UIImage imageNamed:@"WhiteCircleImage"] imageWithTintColor: [UIColor colorWithRed:1.000 green:0.800 blue:0.000 alpha:1.000] blendMode: kCGBlendModeDestinationIn]];
    self.maskView.bounds = CGRectMake(0, 0, 60, 60);
    self.maskView.center = CGPointMake(0, kRect.size.height / 2 + 100);
    self.maskView.backgroundColor = [UIColor clearColor];
    [self.window addSubview: self.maskView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, kRect.size.height / 2 + 100)];
    [path addQuadCurveToPoint: CGPointMake(kRect.size.width / 6, kRect.size.height - 60) controlPoint: CGPointMake(kRect.size.width / 6 - 20, kRect.size.height / 2 + 100)];

    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
    keyAnimation.path = path.CGPath;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    basicAnimation.toValue = [NSValue valueWithCGSize: CGSizeMake(0.8, 0.8)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[keyAnimation, basicAnimation];
    group.delegate = self;
    [group setValue: @"firstStep" forKey: @"animationName"];
    
    [self.maskView.layer addAnimation: group forKey: @"firstStep"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CGRect rect = self.maskView.frame;
    if ([[anim valueForKey: @"animationName"] isEqualToString: @"firstStep"]) {
        [UIView animateWithDuration: 0.1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.maskView.bounds = CGRectMake(0, 0, rect.size.width * 1.2, rect.size.height * 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: 0.1 animations:^{
                self.maskView.bounds = rect;
            }];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint: CGPointMake(kRect.size.width / 6, kRect.size.height - 60)];
            [path addQuadCurveToPoint: CGPointMake(kRect.size.width / 2, kRect.size.height * 3 / 4) controlPoint: CGPointMake(kRect.size.width / 2 - 50, kRect.size.height * 3 / 4 - 50)];
            
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
            keyAnimation.path = path.CGPath;
            
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
            basicAnimation.toValue = [NSValue valueWithCGSize: CGSizeMake(0.5, 0.5)];
            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = 0.6;
            group.fillMode = kCAFillModeForwards;
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            group.animations = @[keyAnimation, basicAnimation];
            group.delegate = self;
            [group setValue: @"secondStep" forKey: @"animationName"];
            
            [self.maskView.layer addAnimation: group forKey: @"secondStep"];
        }];
    } else if ([[anim valueForKey: @"animationName"] isEqualToString: @"secondStep"]) {
        [UIView animateWithDuration: 0.1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.maskView.bounds = CGRectMake(0, 0, rect.size.width * 1.2, rect.size.height * 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: 0.1 animations:^{
                self.maskView.bounds = rect;
            }];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint: CGPointMake(kRect.size.width / 2, kRect.size.height * 3 / 4)];
            [path addLineToPoint: CGPointMake(kRect.size.width / 2, kRect.size.height / 2)];
            
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
            keyAnimation.path = path.CGPath;
            
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
            basicAnimation.toValue = [NSValue valueWithCGSize: CGSizeMake(0.7, 0.7)];
            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = 0.3;
            group.fillMode = kCAFillModeForwards;
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            group.animations = @[keyAnimation, basicAnimation];
            group.delegate = self;
            [group setValue: @"finalStep" forKey: @"animationName"];
            
            [self.maskView.layer addAnimation: group forKey: @"finalStep"];
        }];
    } else if ([[anim valueForKey: @"animationName"] isEqualToString: @"finalStep"]) {
        CGFloat radius = sqrtf(powf(kRect.size.width, 2) + powf(kRect.size.height, 2));

        UIView *maskContentView = [[UIView alloc] init];
        maskContentView.bounds = CGRectMake(0, 0, 42, 42);
        maskContentView.center = CGPointMake(kRect.size.width / 2, kRect.size.height / 2);
        maskContentView.backgroundColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.000 alpha:1.000];
        maskContentView.layer.cornerRadius = 21;
        maskContentView.layer.masksToBounds = YES;
        [self.window addSubview: maskContentView];

        [self.maskView removeFromSuperview];
        self.splashView.layer.mask = maskContentView.layer;
        [UIView animateWithDuration: 0.4 animations:^{
            self.splashView.alpha = 1;
            maskContentView.transform = CGAffineTransformMakeScale(radius / 42, radius / 42);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: 0.6 animations:^{
                self.container.alpha = 0;
            } completion:^(BOOL finished) {
                [self.container removeFromSuperview];
            }];
        }];
        
    }
}

#pragma mark - UITabBarControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC  {
    return self.transition;
}

@end
