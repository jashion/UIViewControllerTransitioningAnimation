//
//  MenuViewController.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/25.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol HandleDismissMenuVC <NSObject>

- (void)dismissWithMenuVC: (MenuViewController *)menuVC;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<HandleDismissMenuVC> delegate;

- (instancetype)initWithBackgroundImage: (UIImage *)backgroundImage;

@end
