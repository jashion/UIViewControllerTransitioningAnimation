//
//  BMInteractiveTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/11.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BMInteractiveTransitionType) {
    BMInteractiveTransitionSnapViewTransform     = 0,
    BMInteractiveTransitionCircleLayer       = 1,
    BMInteractiveTransitionTabBarCircleLayer     = 2
};

@interface BMInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController: (UIViewController *)viewController operation: (BMInteractiveTransitionType)operation;

@end
