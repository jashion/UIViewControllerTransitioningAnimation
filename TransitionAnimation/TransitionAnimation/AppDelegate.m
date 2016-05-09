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
#import "TabTransition.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, assign) CGPoint tapPoint;
@property (nonatomic, strong) TabTransition *transition;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self createTabController];
    [self.window makeKeyAndVisible];
    self.transition = [TabTransition new];
    return YES;
}

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

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC  {
    return self.transition;
}

@end
